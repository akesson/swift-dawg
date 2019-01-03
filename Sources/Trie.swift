//
//  Trie.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

public enum TrieError: Error { case deserializationError }

public class Trie {
    fileprivate let root: TrieNode
    
    public init() {
        root = TrieNode(character: Char.root)
    }
    
    public init(_ serializedNodes: [SerializedNode]) {
        self.root = serializedNodes.deserialized ?? TrieNode(character: Char.root)
    }
    
    public convenience init(csvFile: URL, separator: Character = "\n") throws {
        let text = try String(contentsOf: csvFile, encoding: .utf8)
        self.init(csvFile: text, separator: separator)
    }

    public convenience init(trieFile: URL) throws {
        let data = try Data(contentsOf: trieFile)
        guard let serialized = SerializedNodes.from(data: data) else {
            throw TrieError.deserializationError
        }
        self.init(serialized.array)
    }
    
    public convenience init(csvFile: String, separator: Character = "\n") {
        self.init()
        let lines = csvFile.split(separator: separator)
        lines.forEach({ self.insert(word: $0) })
    }
    
    public convenience init(_ values: String...) {
        self.init()
        values.forEach { insert(word: $0) }
    }
    
    func insert<T: StringProtocol>(word: T) {
        guard !word.isEmpty else { return }
        
        var currentNode = root
        let characters = word.lowercased()
        
        for character in characters {
            currentNode = currentNode.add(child: character)
        }
        currentNode = currentNode.add(child: Char.termination)
    }
    
    public func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root
        let characters = word.lowercased()
        var currentIndex = 0
        
        while currentIndex < characters.count,
            let child = currentNode.findChild(with: characters[currentIndex]) {
            
            currentIndex += 1
            currentNode = child
        }
        
        if currentNode.findChild(with: Char.termination) != nil {
            return currentIndex == characters.count
        }
        return false
    }
    
    public func approximateMatches(for word: String, maxDistance: Int) -> MinValueDictionary {
        let substring = word[word.startIndex..<word.endIndex]
        var found = MinValueDictionary()
        for node in root.children {
            node.search(substring, 0, maxCost: maxDistance, [], &found)
        }
        return found
    }
    
    func serialize() -> SerializedNodes {
        var serialised = [SerializedNode]()
        _ = root.serialize(to: &serialised)
        return SerializedNodes(array: serialised)
    }
    
    public func writeTo(path: URL) throws {
        let data = try serialize().makeData()
        try data.write(to: path)
    }
}

extension Trie: Equatable {
    public static func == (lhs: Trie, rhs: Trie) -> Bool {
        return lhs.root == rhs.root
    }
}
