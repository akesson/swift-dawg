//
//  Array.swift
//  dawg
//
//  Created by Henrik Akesson on 02/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Foundation

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

extension Array {
    func appending(_ newElement: Element) -> [Element] {
        var copy = self
        copy.append(newElement)
        return copy
    }
    
    func reversing() -> [Element] {
        var copy = self
        copy.reverse()
        return copy
    }
}
