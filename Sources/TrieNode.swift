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
    var children = [TrieNode]()
    
    init(character: Character, word: String? = nil) {
        self.character = character
    }
    
    func add(child: Character) -> TrieNode {
        
        if let foundChild = findChild(with: child) {
            return foundChild
        } else {
            let node = TrieNode(character: child)
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
        array.append(SerializedNode(character, childrenAsPositions))
        return Int32(array.count - 1)
    }
    
    convenience init(_ node: SerializedNode, _ children: [TrieNode]) {
        guard let character = node.character?.first else {
            fatalError("Error in serialization: missing character value")
        }
        self.init(character: character)
        self.children = children
    }
}
