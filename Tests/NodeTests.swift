//
//  NodeTests.swift
//  dawgTests
//
//  Created by Henrik Akesson on 30/11/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import dawg

class NodeTests: XCTestCase {

    let catTrie = Trie("cat", "cats", "catsy", "car", "cool", "cooler")
    let abcTrie = Trie("a", "ab", "abc", "abcd", "abcde", "abcdef")
    let oneCharTrie = Trie("y")
    let twoCharTrie = Trie("de")
    
    func testEqualityMatch() {
        let cat2Trie = Trie("cat", "cats", "catsy", "car", "cool", "cooler")
        XCTAssertTrue(catTrie == cat2Trie)
    }
    
    func testEqualityNoMatch() {
        XCTAssertFalse(catTrie == abcTrie)
    }
}
