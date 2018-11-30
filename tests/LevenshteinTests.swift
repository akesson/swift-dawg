//
//  LevenshteinTests.swift
//  dawgTests
//
//  Created by Henrik Akesson on 30/11/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import XCTest
@testable import dawg

class LevenshteinTests: XCTestCase {
    
    func testExample() {
        XCTAssertEqual("abc".levenshtein("ab_"), 1)
        XCTAssertEqual("abc".levenshtein("a_c"), 1)
        XCTAssertEqual("abc".levenshtein("_bc"), 1)
        
        XCTAssertEqual("abc".levenshtein("a__"), 2)
        XCTAssertEqual("abc".levenshtein("___"), 3)
        
        XCTAssertEqual("abc".levenshtein("acb"), 2)
    }
}
