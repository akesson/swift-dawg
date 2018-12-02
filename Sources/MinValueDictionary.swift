//
//  MinValueDictionary.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 02/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

struct MinValueDictionary: CustomStringConvertible, Equatable {
    
    var dict = [String: Int]()
    var count: Int { return dict.count }
    var description: String {
        return dict.keys.sorted().map({ "\(dict[$0] ?? -1) \($0)" }).joined(separator: ", ")
    }
    
    subscript(word: String) -> Int? {
        get {
            return dict[word]
        }
        set {
            guard let cost = newValue else { return }
            if let currentCost = dict[word] {
                if currentCost > cost {
                    dict[word] = cost
                }
            } else {
                dict[word] = cost
            }
        }
    }
}
