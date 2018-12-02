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
    
    func search(_ searched: String.SubSequence,
                currentCost cost: Int,
                maxCost max: Int,
                _ found: inout MinValueDictionary) {
        
        if character == "·" {
            children.values.forEach { $0.search(searched, currentCost: 0, maxCost: max, &found) }
            return
        }
        
        //if there are no more children, you can only delete the remaining chars
        //in the search term (with a cost = amount of chars.
        if children.count == 0 {
            if searched.count == 0 {
                if cost <= max, let word = word {
                    found[word] = cost
                }
                return
            }
            if let char = searched.first, char == character {
                self.search(searched.dropFirst(), currentCost: cost, maxCost: max, &found)
            } else {
                self.search(searched.dropFirst(), currentCost: cost + 1, maxCost: max, &found)
            }
        }
        
        // match condition: searched.count == 0 cost <= max cost and has word
        if let word = word {
            if searched.count == 1, let char = searched.first, char == character {
                found[word] = cost
                debug(cost: cost, searched: searched, foundReason: "match char")
            } else if searched.count == 0 {
                found[word] = cost
                debug(cost: cost, searched: searched, foundReason: "match searched.count")
            } else {
                debug(cost: cost, searched: searched)
            }
        } else {
            debug(cost: cost, searched: searched)
        }
        
        // stop conditions: children.count == 0 or cost == maxCost
        //  note that searched.count == 0 is not a stop critera
        if cost > max {
            return
        }
        
        // [match] character matches
        if let char = searched.first, char == character {
            //search all children for next step
            children.values.forEach { $0.search(searched.dropFirst(), currentCost: cost, maxCost: max, &found) }
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
}

/*
 Case 1. Remaining on end
    d e  -- d e _
      |       |      match

    d e  -- d e _
      |         |   delete

 */
