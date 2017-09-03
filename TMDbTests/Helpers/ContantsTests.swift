//
//  ContantsTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class ContantsTests: XCTestCase {
    
    func testBaseImageURL() {
        XCTAssert(C.BaseImageURLString == "https://image.tmdb.org/t/p")
        XCTAssertFalse(C.BaseImageURLString == "bad data")
    }
    
}
