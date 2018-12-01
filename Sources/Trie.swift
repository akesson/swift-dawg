//
//  Trie.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

class TrieNode: CustomStringConvertible {
    var character: Character
    var children: [Character: TrieNode] = [:]
    var isTerminating = false

    var description: String {
        return "\(character)\(isTerminating ? "." : " ")"
    }

    init(character: Character) {
        self.character = character
    }
    
    func add(child: Character) -> TrieNode {
        if let foundChild = children[child] {
            return foundChild
        } else {
            let node = TrieNode(character: child)
            children[child] = node
            return node
        }
    }
}

class Trie {
    fileprivate let root: TrieNode
    
    init() {
        root = TrieNode(character: "·")
    }
    
    func insert(word: String) {
        guard !word.isEmpty else { return }
        
        var currentNode = root
        let characters = word.lowercased()
        
        for (idx, character) in characters.enumerated() {
            
            currentNode = currentNode.add(child: character)

            if idx == characters.count - 1 {
                currentNode.isTerminating = true
            }
        }
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root
        let characters = word.lowercased()
        var currentIndex = 0
        
        while currentIndex < characters.count,
            let child = currentNode.children[characters[currentIndex]] {
            
            currentIndex += 1
            currentNode = child
        }
        
        return currentIndex == characters.count && currentNode.isTerminating
    }
}
