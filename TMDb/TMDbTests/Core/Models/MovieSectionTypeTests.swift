//
//  MovieSectionTypeTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class MovieSectionTypeTests: XCTestCase {
    
    func testRawValues() {
        XCTAssert(MovieSectionType.upcoming.rawValue    == "upcoming")
        XCTAssert(MovieSectionType.nowplaying.rawValue  == "now_playing")
        XCTAssert(MovieSectionType.toprated.rawValue    == "top_rated")
        XCTAssert(MovieSectionType.popular.rawValue     == "popular")
    }
    
}
