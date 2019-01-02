//
//  Trie.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

class Trie {
    fileprivate let root: TrieNode
    
    init() {
        root = TrieNode(character: ".")
    }
    
    init(_ serializedNodes: [SerializedNode]) {
        self.root = serializedNodes.deserialized ?? TrieNode(character: ".")
    }
    
    convenience init(csvFile: String, separator: Character = "\n") {
        self.init()
        let lines = csvFile.split(separator: separator)
        lines.forEach({ self.insert(word: String($0)) })
    }
    
    convenience init(_ values: String...) {
        self.init()
        values.forEach { insert(word: $0) }
    }
    
    func insert(word: String) {
        guard !word.isEmpty else { return }
        
        var currentNode = root
        let characters = word.lowercased()
        
        for character in characters {
            currentNode = currentNode.add(child: character, word: nil)
        }
        currentNode = currentNode.add(child: ".", word: word)
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root
        let characters = word.lowercased()
        var currentIndex = 0
        
        while currentIndex < characters.count,
            let child = currentNode.findChild(with: characters[currentIndex]) {
            
            currentIndex += 1
            currentNode = child
        }
        
        if currentNode.findChild(with: ".") != nil {
            return currentIndex == characters.count
        }
        return false
    }
    
    func approximateMatches(for word: String, maxDistance: Int) -> MinValueDictionary {
        let substring = word[word.startIndex..<word.endIndex]
        var found = MinValueDictionary()
        for node in root.children {
            node.search(substring, currentCost: 0, maxCost: maxDistance, &found)
        }
        return found
    }
    
    func serialize() -> SerializedNodes {
        var serialised = [SerializedNode]()
        _ = root.serialize(to: &serialised)
        return SerializedNodes(array: serialised)
    }
}

extension Trie: Equatable {
    static func == (lhs: Trie, rhs: Trie) -> Bool {
        return lhs.root == rhs.root
    }
}
