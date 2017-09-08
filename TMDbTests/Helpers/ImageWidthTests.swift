//
//  ImageWidthTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class ImageWidthTests: XCTestCase {
    
    func testRawValues() {
        XCTAssert(ImageWidth.w92.rawValue == "w92")
        XCTAssert(ImageWidth.w185.rawValue == "w185")
        XCTAssert(ImageWidth.w500.rawValue == "w500")
        XCTAssert(ImageWidth.w780.rawValue == "w780")
    }
    
    func testURL() {
        var w = ImageWidth.w92
        
        XCTAssert(w.url(for: "/abc.jpg")!.absoluteString == "https://image.tmdb.org/t/p/w92/abc.jpg")
        
        w = .w185
        XCTAssert(w.url(for: "/xyz.jpg")!.absoluteString == "https://image.tmdb.org/t/p/w185/xyz.jpg")
        
        w = .w500
        XCTAssert(w.url(for: "/a")!.absoluteString == "https://image.tmdb.org/t/p/w500/a")
        
        w = .w780
        XCTAssert(w.url(for: "random.jpg")!.absoluteString == "https://image.tmdb.org/t/p/w780/random.jpg")
    }
    
    // Poster
    func test92Poster() {
        validatePoster(.w92, width: 92, height: 135)
    }
    
    func test185Poster() {
        validatePoster(.w185, width: 185, height: 278)
    }
    
    func test500Poster() {
        validatePoster(.w500, width: 500, height: 735)
    }
    
    func test780Poster() {
        validatePoster(.w780, width: 780, height: 1147)
    }
    
    private func validatePoster(_ imageWidth: ImageWidth, width: Int, height: Int) {
        XCTAssert(imageWidth.width == width)
        XCTAssert(imageWidth.posterHeight == height)
        XCTAssert(imageWidth.posterSize == CGSize(width: width, height: height))
        
        XCTAssertFalse(imageWidth.width == 123)
        XCTAssertFalse(imageWidth.posterHeight == 456)
        XCTAssertFalse(imageWidth.posterSize == CGSize(width: 123, height: 456))
    }
    
    // Backdrop
    func test92Backdrop() {
        validateBackdrop(.w92, width: 92, height: 52)
    }
    
    func test185Backdrop() {
        validateBackdrop(.w185, width: 185, height: 104)
    }
    
    func test500Backdrop() {
        validateBackdrop(.w500, width: 500, height: 281)
    }
    
    func test780Backdrop() {
        validateBackdrop(.w780, width: 780, height: 439)
    }
    
    private func validateBackdrop(_ imageWidth: ImageWidth, width: Int, height: Int) {
        XCTAssert(imageWidth.width == width)
        XCTAssert(imageWidth.backdropHeight == height)
        XCTAssert(imageWidth.backdropSize == CGSize(width: width, height: height))
        
        XCTAssertFalse(imageWidth.width == 123)
        XCTAssertFalse(imageWidth.backdropHeight == 456)
        XCTAssertFalse(imageWidth.backdropSize == CGSize(width: 123, height: 456))
    }
    
}
