//
//  Trie.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

class TrieNode<T: Hashable> {
    var value: T
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    
    init(value: T) {
        self.value = value
    }
    
    func add(child: T) -> TrieNode {
        if let foundChild = children[child] {
            return foundChild
        } else {
            let node = TrieNode(value: child)
            children[child] = node
            return node
        }
    }
}

extension TrieNode: CustomStringConvertible where T == Character {
    var description: String {
        return "\(value)\(isTerminating ? "." : " ")"
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    
    fileprivate let root: Node
    
    init() {
        root = Node(value: "·")
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
