//
//  ImageDownloadableTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

struct MockDownloadable: ImageDownloadable {
    let posterPath: String?
    let backdropPath: String?
}

class ImageDownloadableTests: XCTestCase {
    
    var mock: MockDownloadable!
    var imageWidth: ImageWidth!
    
    override func tearDown() {
        mock = nil
        imageWidth = nil
        super.tearDown()
    }
    
    func testPosterURL() {
        mock = MockDownloadable(posterPath: "/abc.jpg", backdropPath: nil)
        imageWidth = .w92
        
        let expectedURL = URL(string: "https://image.tmdb.org/t/p/w92/abc.jpg")
        let firstWrongURL = URL(string: "https://image.tmdb.org/t/p/abc.jpg")
        let secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w92")
        XCTAssert(mock.posterURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.posterURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.posterURL(width: imageWidth) == secondWrongURL)
        
        XCTAssertNil(mock.backdropURL(width: imageWidth))
    }
    
    func testBackdropURL() {
        mock = MockDownloadable(posterPath: nil, backdropPath: "/xyz.jpg")
        imageWidth = .w185

        let expectedURL = URL(string: "https://image.tmdb.org/t/p/w185/xyz.jpg")
        let firstWrongURL = URL(string: "https://image.tmdb.org/t/p/xyz.jpg")
        let secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w185")
        XCTAssert(mock.backdropURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == secondWrongURL)
        
        XCTAssertNil(mock.posterURL(width: imageWidth))
    }
    
    func testBothURLs() {
        mock = MockDownloadable(posterPath: "/abc.jpg", backdropPath: "/xyz.jpg")
        imageWidth = .w780

        // Poster
        var expectedURL = URL(string: "https://image.tmdb.org/t/p/w780/xyz.jpg")
        var firstWrongURL = URL(string: "https://image.tmdb.org/t/p/xyz.jpg")
        var secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w780")
        XCTAssert(mock.backdropURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == secondWrongURL)
        
        // Backdrop
        expectedURL = URL(string: "https://image.tmdb.org/t/p/w780/xyz.jpg")
        firstWrongURL = URL(string: "https://image.tmdb.org/t/p/xyz.jpg")
        secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w780")
        XCTAssert(mock.backdropURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == secondWrongURL)
    }
    
    // Defaults
    func testDefaultPosterURL() {
        mock = MockDownloadable(posterPath: "/abc.jpg", backdropPath: nil)
        let expectedURL = URL(string: "https://image.tmdb.org/t/p/w185/abc.jpg")
        XCTAssert(mock.posterURL() == expectedURL)
        XCTAssertNil(mock.backdropURL())
    }
    
    func testDefaultBackdropURL() {
        mock = MockDownloadable(posterPath: nil, backdropPath: "/xyz.jpg")
        let expectedURL = URL(string: "https://image.tmdb.org/t/p/w500/xyz.jpg")
        XCTAssert(mock.backdropURL() == expectedURL)
        XCTAssertNil(mock.posterURL())
    }
    
    func testDefaultBothURLs() {
        mock = MockDownloadable(posterPath: "/abc.jpg", backdropPath: "/xyz.jpg")
        let expectedPosterURL = URL(string: "https://image.tmdb.org/t/p/w185/abc.jpg")
        let expectedBackdropURL = URL(string: "https://image.tmdb.org/t/p/w500/xyz.jpg")
        XCTAssert(mock.posterURL() == expectedPosterURL)
        XCTAssert(mock.backdropURL() == expectedBackdropURL)
    }
    
}
