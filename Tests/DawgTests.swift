//
//  DawgTests.swift
//  dawgTests
//
//  Created by Henrik Akesson on 30/11/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import dawg

class DawgTests: XCTestCase {

    let catTrie = Trie("cat", "cats", "catsy", "car", "cool", "cooler")
    let abcTrie = Trie("a", "ab", "abc", "abcd", "abcde", "abcdef")
    let oneCharTrie = Trie("y")
    let twoCharTrie = Trie("de")
    
    func testOneCharTrieMatch() {
        let found = oneCharTrie.approximateMatches(for: "y", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["y"], 0)
    }
    
    func testOneCharTrieDeleteFirst() {
        let found = oneCharTrie.approximateMatches(for: "_y", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["y"], 1)
    }

    func testOneCharTrieDeleteLast() {
        let found = oneCharTrie.approximateMatches(for: "y_", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["y"], 1)
    }

    func testTwoCharTrieMatch() {
        let found = twoCharTrie.approximateMatches(for: "de", maxDistance: 0)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 0)
    }
    
    func testTwoCharTrieReplaceStart() {
        let found = twoCharTrie.approximateMatches(for: "_e", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }

    func testTwoCharTrieReplaceEnd() {
        let found = twoCharTrie.approximateMatches(for: "d_", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }
    
    func testTwoCharTrieDeleteStart() {
        let found = twoCharTrie.approximateMatches(for: "_de", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }

    func testTwoCharTrieDeleteEnd() {
        let found = twoCharTrie.approximateMatches(for: "de_", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }

    func testTwoCharTrieDeleteTwoEnd() {
        let found = twoCharTrie.approximateMatches(for: "de__", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 2)
    }

    func testTwoCharTrieFirstChar() {
        let found = twoCharTrie.approximateMatches(for: "d", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }

    func testTwoCharTrieLastChar() {
        let found = twoCharTrie.approximateMatches(for: "e", maxDistance: 1)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["de"], 1)
    }

    func testExitConditionBeforeAndAfter() {
        // words: a, ab, abc, abcd, abcde, abcdef
        
        let found = abcTrie.approximateMatches(for: "abc", maxDistance: 2)
        
        XCTAssertEqual(found.count, 5)
        XCTAssertEqual(found["a"], 2)
        XCTAssertEqual(found["ab"], 1)
        XCTAssertEqual(found["abc"], 0)
        XCTAssertEqual(found["abcd"], 1)
        XCTAssertEqual(found["abcde"], 2)
    }

    func testExitConditionInserts() {
        // words: a, ab, abc, abcd, abcde, abcdef
        var found: MinValueDictionary
        found = abcTrie.approximateMatches(for: "__abc", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abc"], 2)

        found = abcTrie.approximateMatches(for: "a__bc", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abc"], 2)

        found = abcTrie.approximateMatches(for: "ab__c", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abc"], 2)

        found = abcTrie.approximateMatches(for: "abc__", maxDistance: 2)
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["abc"], 2)
        XCTAssertEqual(found["abcd"], 2)
        XCTAssertEqual(found["abcde"], 2)
    }

    func testExitConditionDeletes() {
        // words: a, ab, abc, abcd, abcde, abcdef, abcdefg, abcdefgh
        var found: MinValueDictionary
        found = abcTrie.approximateMatches(for: "cde", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abcde"], 2)
        
        found = abcTrie.approximateMatches(for: "ade", maxDistance: 2)
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["a"], 2)
        XCTAssertEqual(found["ab"], 2)
        XCTAssertEqual(found["abc"], 2)
        XCTAssertEqual(found["abcde"], 2)
        
        found = abcTrie.approximateMatches(for: "abe", maxDistance: 2)
        XCTAssertEqual(found.count, 5)
        XCTAssertEqual(found["a"], 2)
        XCTAssertEqual(found["ab"], 1)
        XCTAssertEqual(found["abcd"], 2)
        XCTAssertEqual(found["abcde"], 2)
    }

    func testExitConditionReplace() {
        // words: a, ab, abc, abcd, abcde, abcdef
        var found: MinValueDictionary
        found = abcTrie.approximateMatches(for: "__cde", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abcde"], 2)

        found = abcTrie.approximateMatches(for: "a__de", maxDistance: 2)
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found["abcde"], 2)

        found = abcTrie.approximateMatches(for: "abc__", maxDistance: 2)
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["abc"], 2)
        XCTAssertEqual(found["abcd"], 2)
        XCTAssertEqual(found["abcde"], 2)
    }

    func testInsertOneBeginning() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "rcats", maxDistance: 2)
        
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
    }
    
    func testInsertEnd() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "catsr", maxDistance: 2)
        
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 1)
        XCTAssertEqual(found["cat"], 2)
        XCTAssertEqual(found["car"], 2)
    }

    func testInsertMiddle() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "carts", maxDistance: 2)
        
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
        XCTAssertEqual(found["car"], 2)
    }

    func testDeleteBeginning() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "ats", maxDistance: 2)
        
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
    }
    
    func testDeleteEnd() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "ca", maxDistance: 2)
        
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["cat"], 1)
        XCTAssertEqual(found["car"], 1)
        XCTAssertEqual(found["cats"], 2)
    }
    
    func testDeleteMiddle() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "cts", maxDistance: 2)
        
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
        XCTAssertEqual(found["car"], 2)
    }

    func testReplaceBeginning() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "bats", maxDistance: 2)
        
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
    }
    
    func testReplaceEnd() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "catr", maxDistance: 2)
        
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 1)
        XCTAssertEqual(found["car"], 1)
    }
    
    func testReplaceMiddle() {
        //words: cat, cats, catsy, car, cool, cooler
        let found = catTrie.approximateMatches(for: "cabs", maxDistance: 2)
        
        XCTAssertEqual(found.count, 4)
        XCTAssertEqual(found["cats"], 1)
        XCTAssertEqual(found["catsy"], 2)
        XCTAssertEqual(found["cat"], 2)
        XCTAssertEqual(found["car"], 2)
    }
}
