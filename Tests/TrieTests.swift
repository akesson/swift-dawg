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
    
    func convertCSVToTrieFile() {
        do {
            guard let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                XCTFail("dir not found")
                return
            }
            
            let fileURL = dir.appendingPathComponent("panlex_20181201_csv.public.csv_wordlist.csv")
            
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            
            let trie = Trie(csvFile: text)
            let serialized = trie.serialize()
            let data = try serialized.makeData()
            
            let outURL = dir.appendingPathComponent("wordlist.trie")
            try data.write(to: outURL)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func readFromTrieFile() {
        do {
            guard let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                XCTFail("dir not found")
                return
            }
            
            let fileURL = dir.appendingPathComponent("wordlist.trie")
            
            let data = try Data(contentsOf: fileURL)
            guard let serialized = SerializedNodes.from(data: data) else {
                XCTFail("Could not deserialize")
                return
            }
            
            let trie = Trie(serialized.array)
            let vals = trie.approximateMatches(for: "bus", maxDistance: 1)
            XCTAssertEqual(vals.count, 24)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
