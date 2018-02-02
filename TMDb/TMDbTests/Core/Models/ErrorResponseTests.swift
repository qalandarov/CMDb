//
//  ErrorResponseTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class ErrorResponseTests: XCTestCase, StubRequestable {
    
    func testError() {
        guard let error: ErrorResponse = decodable(from: "error-response") else { return }
        
        XCTAssert(error.code == 25)
        XCTAssert(error.message == "Your request count (41) is over the allowed limit of 40.")
    }
    
}
