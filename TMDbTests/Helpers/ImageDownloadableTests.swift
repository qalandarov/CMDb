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
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    func testPosterURL() {
        mock = MockDownloadable(posterPath: "/abc.jpg", backdropPath: nil)
        let imageWidth = ImageWidth.w92
        
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
        let imageWidth = ImageWidth.w185
        
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
        let imageWidth = ImageWidth.w500
        
        // Poster
        var expectedURL = URL(string: "https://image.tmdb.org/t/p/w500/xyz.jpg")
        var firstWrongURL = URL(string: "https://image.tmdb.org/t/p/xyz.jpg")
        var secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w500")
        XCTAssert(mock.backdropURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == secondWrongURL)
        
        // Backdrop
        expectedURL = URL(string: "https://image.tmdb.org/t/p/w500/xyz.jpg")
        firstWrongURL = URL(string: "https://image.tmdb.org/t/p/xyz.jpg")
        secondWrongURL = URL(string: "https://image.tmdb.org/t/p/w500")
        XCTAssert(mock.backdropURL(width: imageWidth) == expectedURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == firstWrongURL)
        XCTAssertFalse(mock.backdropURL(width: imageWidth) == secondWrongURL)
    }
    
}
