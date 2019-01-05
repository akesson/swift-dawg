//
//  Array.swift
//  dawg
//
//  Created by Henrik Akesson on 02/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Foundation

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
