//
//  TrieNode.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 02/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

class TrieNode: CustomStringConvertible, Node {
    let character: Character
    let word: String?
    var children = [TrieNode]()
    
    init(character: Character, word: String? = nil) {
        self.character = character
        self.word = word
    }
    
    func add(child: Character, word: String?) -> TrieNode {
        
        if let foundChild = findChild(with: child) {
            return foundChild
        } else {
            let node = TrieNode(character: child, word: word)
            children.append(node)
            return node
        }
    }
}

// MARK: - Serialization and deserialisation

extension TrieNode {
    
    /// depth-first serialization of nodes (root is the last one)
    func serialize(to array: inout [SerializedNode]) -> Int32 {
        let childrenAsPositions = children.map({ $0.serialize(to: &array) })
        array.append(SerializedNode(character, word, childrenAsPositions))
        return Int32(array.count - 1)
    }
    
    convenience init(_ node: SerializedNode, _ children: [TrieNode]) {
        guard let character = node.word?.first else {
            fatalError("Error in serialization: missing character value")
        }
        self.init(character: character, word: node.word)
        self.children = children
    }
}
