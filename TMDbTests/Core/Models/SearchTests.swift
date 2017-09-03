//
//  SearchTests.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import XCTest
@testable import TMDb

class SearchTests: XCTestCase, StubRequestable {
    
    func testSearchResult_OneResult() {
        let search: Search<Movie>? = self.search(from: "search-one-movie")
        
        XCTAssert(search?.page == 1)
        XCTAssert(search?.totalPages == 1)
        XCTAssert(search?.totalResults == 1)
        XCTAssert(search?.results.count == 1)
    }
    
    func testSearchResult_TwoResults() {
        let search: Search<Movie>? = self.search(from: "search-two-movies")
        
        XCTAssert(search?.page == 1)
        XCTAssert(search?.totalPages == 1)
        XCTAssert(search?.totalResults == 2)
        XCTAssert(search?.results.count == 2)
    }
    
    private func search<T>(from fileName: String) -> Search<T>? {
        guard
            let jsonData = requestJSONStub(with: fileName),
            let search = try? JSONDecoder().decode(Search<T>.self, from: jsonData)
            else {
                XCTFail("Couldn't get the stub")
                return nil
        }
        
        return search
    }
    
}
