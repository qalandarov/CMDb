//
//  MovieTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class MovieTests: XCTestCase, StubRequestable {
    
    func testMovie_Basic() {
        guard let movie: Movie = decodable(from: "movie") else { return }
        
        XCTAssert(movie.id == 268)
        XCTAssert(movie.title == "Batman")
        XCTAssert(movie.originalTitle == "Batman")
        XCTAssert(movie.releaseDate == "1989-06-23")
        XCTAssert(movie.posterPath == "/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg")
        XCTAssert(movie.backdropPath == "/2blmxp2pr4BhwQr74AdCfwgfMOb.jpg")
        XCTAssert(movie.genres == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
    func testMovie_NilPoster() {
        guard let movie: Movie = decodable(from: "movie-null-poster") else { return }
        
        XCTAssert(movie.id == 268)
        XCTAssert(movie.title == "Batman")
        XCTAssert(movie.originalTitle == "Batman")
        XCTAssert(movie.releaseDate == "1989-06-23")
        XCTAssert(movie.posterPath == nil)
        XCTAssert(movie.backdropPath == "/2blmxp2pr4BhwQr74AdCfwgfMOb.jpg")
        XCTAssert(movie.genres == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
    func testMovie_NilBackdrop() {
        guard let movie: Movie = decodable(from: "movie-null-backdrop") else { return }
        
        XCTAssert(movie.id == 268)
        XCTAssert(movie.title == "Batman")
        XCTAssert(movie.originalTitle == "Batman")
        XCTAssert(movie.releaseDate == "1989-06-23")
        XCTAssert(movie.posterPath == "/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg")
        XCTAssert(movie.backdropPath == nil)
        XCTAssert(movie.genres == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
    func testMovie_NilPosterAndBackdrop() {
        guard let movie: Movie = decodable(from: "movie-null-poster-and-backdrop") else { return }
        
        XCTAssert(movie.id == 268)
        XCTAssert(movie.title == "Batman")
        XCTAssert(movie.originalTitle == "Batman")
        XCTAssert(movie.releaseDate == "1989-06-23")
        XCTAssert(movie.posterPath == nil)
        XCTAssert(movie.backdropPath == nil)
        XCTAssert(movie.genres == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
}
