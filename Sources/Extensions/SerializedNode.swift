//
//  SerializedNode.swift
//  dawg
//
//  Created by Henrik Akesson on 29/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

extension SerializedNode {
    convenience init(_ character: Character, _ word: String?, _ children: [Int32]) {
        self.init(character: String(character), word: word, children: children)
    }
}

extension Array where Element == SerializedNode {
    var deserialized: TrieNode? {
        var serialized = [TrieNode]()
        for index in 0..<self.count {
            let toDeserialize = self[index]
            let children = toDeserialize.children.map({ serialized[Int($0)] })
            let node = TrieNode(toDeserialize, children)
            serialized.append(node)
        }
        return serialized.last
    }
}
