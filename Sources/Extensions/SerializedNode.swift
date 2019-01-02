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
