//
//  Trie.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

public enum TrieError: Error {
    case deserializationError
    case ingestionCountMismatch(added: Int, found: Int)
    case wordMismatch(index: Int, added: String, found: String)
}

public class Trie {
    fileprivate let root: TrieNode
    
    public init() {
        root = TrieNode(Char.root)
    }
    
    public convenience init(csvFile: URL, separator: Character = "\n") throws {
        let text = try String(contentsOf: csvFile, encoding: .utf8)
        try self.init(csvFile: text, separator: separator)
    }

    public convenience init(trieFile: URL) throws {
        let data = try Data(contentsOf: trieFile)
        guard let serialized = SerializedNodes.from(data: data) else {
            throw TrieError.deserializationError
        }
        self.init(serialized)
    }
    
    public init(_ serialized: SerializedNodes) {
        var deserialized = [TrieNode]()

        var scalars = serialized.scalars.makeIterator()
        
        for childCount in serialized.childCount {
            
            var children = [TrieNode]()
            let char = Character(UnicodeScalar(scalars.next()!)!)
            
            for _ in 0..<childCount {
                let childPos = Int(scalars.next()!)
                children.append(deserialized[childPos])
            }
            
            deserialized.append(TrieNode(char, children))
        }
        self.root = deserialized.last ?? TrieNode(Char.root)
    }
    
    public convenience init(csvFile: String, separator: Character = "\n") throws {
        self.init()
        let lines = csvFile.split(separator: separator).map({ $0.lowercased() })
        lines.forEach({ self.insert(word: $0) })
//        try verifyIngestion(lines)
    }
    
    public convenience init(_ values: String...) {
        self.init()
        values.forEach { insert(word: $0) }
    }
    
    private func verifyIngestion<T: StringProtocol>(_ lines: [T]) throws {
        var foundWords = self.listAllWords()
        //remove duplicates
        var addedWords = Array(Set(lines))
        guard foundWords.count == addedWords.count else {
            throw TrieError.ingestionCountMismatch(added: addedWords.count, found: foundWords.count)
        }
        addedWords.sort()
        foundWords.sort()
        for index in 0..<addedWords.count where foundWords[index] != addedWords[index] {
            throw TrieError.wordMismatch(index: index,
                                         added: String(addedWords[index]),
                                         found: String(foundWords[index]))
        }
    }
    
    func insert<T: StringProtocol>(word: T) {
        guard !word.isEmpty else { return }
        root.insert(word, [Character]())
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
    
    public func listAllWords() -> [String] {
        var words = [String]()
        root.children.forEach({ $0.listWords(&words, path: [Character]()) })
        return words
    }
    
    public func approximateMatches(for word: String, maxDistance: Int) -> MinValueDictionary {
        let substring = word.lowercased()[word.startIndex..<word.endIndex]
        var found = MinValueDictionary()
        for node in root.children {
            node.search(substring, 0, maxCost: maxDistance, [], &found)
        }
        return found
    }
    
    func serialize() -> SerializedNodes {
        let serialised = SerializedNodes()
        _ = root.serialize(to: serialised)
        return serialised
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
