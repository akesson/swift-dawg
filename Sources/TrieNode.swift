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
    var children: [TrieNode]
    
    init(_ character: Character, _ children: [TrieNode]? = nil) {
        self.character = character
        self.children = children ?? [TrieNode]()
    }
    
    func add(child: Character) -> TrieNode {
        
        if let foundChild = findChild(with: child) {
            return foundChild
        } else {
            let node = TrieNode(child)
            children.append(node)
            return node
        }
    }
}

// MARK: - Serialization and deserialisation

extension TrieNode {
    
    /// depth-first serialization of nodes (root is the last one)
    func serialize(to serialized: SerializedNodes) -> UInt32 {
        
        let childrenAsPositions = children.map({ $0.serialize(to: serialized) })
        let scalars = character.asScalars
        guard scalars.count == 1 else {
            fatalError("Can only handle one")
        }
        serialized.scalars.append(contentsOf: scalars)
        
        serialized.childCount.append(Int16(childrenAsPositions.count))
        serialized.scalars.append(contentsOf: childrenAsPositions)
        return UInt32(serialized.childCount.count - 1)
    }
}
