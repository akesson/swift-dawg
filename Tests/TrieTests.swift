//
//  TrieTests.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 01/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import dawg

class TrieTests: XCTestCase {
    
    func test() {
        let trie = Trie()
        
        trie.insert(word: "cute")
        XCTAssertTrue(trie.contains(word: "cute"))
        
        XCTAssertFalse(trie.contains(word: "cut"))
        trie.insert(word: "cut")
        XCTAssertTrue(trie.contains(word: "cut"))

        XCTAssertFalse(trie.contains(word: "cobra"))
        trie.insert(word: "cobra")
        XCTAssertTrue(trie.contains(word: "cobra"))

    }
}
