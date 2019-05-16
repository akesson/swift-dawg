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
        XCTAssertFalse(oneCharTrie == twoCharTrie)
    }
    
    func testSerializeInMemory() {
        let serialized = catTrie.serialize()
        let catTrieFromSerialized = Trie(serialized)
        XCTAssertTrue(catTrie == catTrieFromSerialized)
    }

    func testSerializeToData() throws {
        let serializer = catTrie.serialize()
        let data = try serializer.makeData()
        
        let deserializer = SerializedNodes.from(data: data)
        guard let array = deserializer else {
            XCTFail("no data")
            return
        }
        let catTrieFromSerialized = Trie(array)
        XCTAssertTrue(catTrie == catTrieFromSerialized)
    }
}
