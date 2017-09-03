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
    
    func test92() {
        validate(.w92, width: 92, height: 135)
    }
    
    func test185() {
        validate(.w185, width: 185, height: 278)
    }
    
    func test500() {
        validate(.w500, width: 500, height: 735)
    }
    
    func test780() {
        validate(.w780, width: 780, height: 1147)
    }
    
    private func validate(_ imageWidth: ImageWidth, width: Int, height: Int) {
        XCTAssert(imageWidth.width == width)
        XCTAssert(imageWidth.height == height)
        XCTAssert(imageWidth.size == CGSize(width: width, height: height))
        
        XCTAssertFalse(imageWidth.width == 123)
        XCTAssertFalse(imageWidth.height == 456)
        XCTAssertFalse(imageWidth.size == CGSize(width: 123, height: 456))
    }
    
}
