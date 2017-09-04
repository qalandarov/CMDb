//
//  MovieGenreTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class MovieGenreTests: XCTestCase {
    
    func testRawValues() {
        XCTAssert(MovieGenre.action.rawValue            == 28)
        XCTAssert(MovieGenre.adventure.rawValue         == 12)
        XCTAssert(MovieGenre.animation.rawValue         == 16)
        XCTAssert(MovieGenre.comedy.rawValue            == 35)
        XCTAssert(MovieGenre.crime.rawValue             == 80)
        XCTAssert(MovieGenre.documentary.rawValue       == 99)
        XCTAssert(MovieGenre.drama.rawValue             == 18)
        XCTAssert(MovieGenre.family.rawValue            == 10751)
        XCTAssert(MovieGenre.fantasy.rawValue           == 14)
        XCTAssert(MovieGenre.foreign.rawValue           == 10769)
        XCTAssert(MovieGenre.history.rawValue           == 36)
        XCTAssert(MovieGenre.horror.rawValue            == 27)
        XCTAssert(MovieGenre.music.rawValue             == 10402)
        XCTAssert(MovieGenre.mystery.rawValue           == 9648)
        XCTAssert(MovieGenre.romance.rawValue           == 10749)
        XCTAssert(MovieGenre.scienceFiction.rawValue    == 878)
        XCTAssert(MovieGenre.tvMovie.rawValue           == 10770)
        XCTAssert(MovieGenre.thriller.rawValue          == 53)
        XCTAssert(MovieGenre.war.rawValue               == 10752)
        XCTAssert(MovieGenre.western.rawValue           == 37)
    }
    
}
