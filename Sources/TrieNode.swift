//
//  TrieNode.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 02/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

class TrieNode: CustomStringConvertible {
    var character: Character
    var word: String?
    var children: [Character: TrieNode] = [:]
    weak var parent: TrieNode?
    
    var path: String { return "\(parent?.path ?? "")\(description)" }
    
    var isTerminating: Bool { return word != nil }
    var isRoot: Bool { return character == "·"}
    
    var description: String { return "\(character)\(isTerminating ? "." : "")" }
    
    init(character: Character, parent: TrieNode? = nil) {
        self.character = character
        self.parent = parent
    }
    
    func add(child: Character) -> TrieNode {
        if let foundChild = children[child] {
            return foundChild
        } else {
            let node = TrieNode(character: child, parent: self)
            children[child] = node
            return node
        }
    }
    
    func debug(cost: Int, searched: String.SubSequence, foundReason: String? = nil) {
        //print("\(cost)  \(path) == \(searched) \(foundReason ?? "")")
    }

    func searchTerminating(_ searched: String.SubSequence,
                           currentCost cost: Int,
                           maxCost max: Int,
                           _ found: inout MinValueDictionary) {
        
        //if there are any search characters left,
        //they will have to be deleted
        let totalCost = searched.count + cost
        if totalCost <= max, let word = word {
            found[word] = totalCost
        }
    }
    
    func searchNode(_ searched: String.SubSequence,
                    currentCost cost: Int,
                    maxCost max: Int,
                    _ found: inout MinValueDictionary) {
        
        // [match] character matches
        if let char = searched.first, char == character {
            //search all children for next step
            for child in children.values {
                child.search(searched.dropFirst(), currentCost: cost, maxCost: max, &found)
            }
        }
        
        // [delete] skip one from search term and try with same node
        self.search(searched.dropFirst(), currentCost: cost + 1, maxCost: max, &found)
        
        // [insert] skip this node
        for child in children.values {
            child.search(searched, currentCost: cost + 1, maxCost: max, &found)
        }
        
        // [replace] skip node + skip one char from search term
        for child in children.values {
            child.search(searched.dropFirst(), currentCost: cost + 1, maxCost: max, &found)
        }
    }
    
    func search(_ searched: String.SubSequence,
                currentCost cost: Int,
                maxCost max: Int,
                _ found: inout MinValueDictionary) {
        
        if cost > max {
            return
        } else if isTerminating {
            searchTerminating(searched, currentCost: cost, maxCost: max, &found)
        } else {
            searchNode(searched, currentCost: cost, maxCost: max, &found)
        }
    }
}