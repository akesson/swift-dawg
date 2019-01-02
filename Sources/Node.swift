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
    var children: [TrieNode] { get }
}

struct Char {
    static let termination: Character = "#"
    static var root: Character = "@"
}

// MARK: - calculated properties

extension Node {
    var isTerminating: Bool { return character == Char.termination }
    var isRoot: Bool { return character == Char.root }
    
    var description: String { return "\(character)\(isTerminating ? "." : "")" }
}

// MARK: - searching

extension Node {
    func findChild(with character: Character) -> TrieNode? {
        return children.first(where: { $0.character == character })
    }
    
    func searchTerminating(_ searched: String.SubSequence,
                           _ cost: Int,
                           maxCost max: Int,
                           _ path: [Character],
                           _ found: inout MinValueDictionary) {
        
        //if there are any search characters left,
        //they will have to be deleted
        let totalCost = searched.count + cost
        if totalCost <= max {
            let word = String(path)
            found[word] = totalCost
        }
    }
    
    func searchNode(_ searched: String.SubSequence,
                    _ cost: Int,
                    maxCost max: Int,
                    _ path: [Character],
                    _ found: inout MinValueDictionary) {

        let newPath = path.appending(character)

        // [match] character matches
        if let char = searched.first, char == character {
            //search all children for next step
            for child in children {
                child.search(searched.dropFirst(), cost, maxCost: max, newPath, &found)
            }
        }
        
        // [delete] skip one from search term and try with same node
        self.search(searched.dropFirst(), cost + 1, maxCost: max, path, &found)
        
        // [insert] skip this node
        for child in children {
            child.search(searched, cost + 1, maxCost: max, newPath, &found)
        }
        
        // [replace] skip node + skip one char from search term
        for child in children {
            child.search(searched.dropFirst(), cost + 1, maxCost: max, newPath, &found)
        }
    }
    
    func search(_ searched: String.SubSequence,
                _ cost: Int,
                maxCost max: Int,
                _ path: [Character],
                _ found: inout MinValueDictionary) {
        
        if cost > max {
            return
        } else if isTerminating {
            searchTerminating(searched, cost, maxCost: max, path, &found)
        } else {
            searchNode(searched, cost, maxCost: max, path, &found)
        }
    }
}

// MARK: - Equality

func == <T: Node>(lhs: T, rhs: T) -> Bool {
    guard lhs.character == rhs.character,
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
