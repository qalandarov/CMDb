//
//  ErrorTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class ErrorTests: XCTestCase {
    
    var error: TMDb.Error!
    
    override func tearDown() {
        error = nil
        super.tearDown()
    }
    
    func testGeneral_init() {
        error = Error("Error message")
        XCTAssert(error.string == "Error message")
    }
    
    func testGeneral() {
        error = Error.general(errorMsg: "Any other message")
        XCTAssert(error.string == "Any other message")
    }
    
    func testIncorrectResponse() {
        error = Error.incorrectResponse
        XCTAssert(error.string == "Unexpected response received from the server")
    }
    
    func testIncorrectRequest() {
        error = Error.incorrectRequest
        XCTAssert(error.string == "Something is wrong with the configurations")
    }
    
}
