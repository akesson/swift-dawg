//
//  Node.swift
//  dawg
//
//  Created by Henrik Akesson on 01/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Foundation

protocol Node: Equatable {
    var character: Character { get }
    var word: String? { get }
    var children: [TrieNode] { get }
}

// MARK: - calculated properties

extension Node {
    var isTerminating: Bool { return word != nil }
    var isRoot: Bool { return character == "·"}
    
    var description: String { return "\(character)\(isTerminating ? "." : "")" }
}

// MARK: - searching

extension Node {
    func findChild(with character: Character) -> TrieNode? {
        return children.first(where: { $0.character == character })
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
            for child in children {
                child.search(searched.dropFirst(), currentCost: cost, maxCost: max, &found)
            }
        }
        
        // [delete] skip one from search term and try with same node
        self.search(searched.dropFirst(), currentCost: cost + 1, maxCost: max, &found)
        
        // [insert] skip this node
        for child in children {
            child.search(searched, currentCost: cost + 1, maxCost: max, &found)
        }
        
        // [replace] skip node + skip one char from search term
        for child in children {
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

// MARK: - Equality

func == <T: Node>(lhs: T, rhs: T) -> Bool {
    guard lhs.character == rhs.character,
        lhs.word == rhs.word,
        lhs.children.count == rhs.children.count else {
            return false
    }
    
    for index in 0..<lhs.children.count {
        guard lhs.children[index] == rhs.children[index] else {
            return false
        }
    }
    return true
}
