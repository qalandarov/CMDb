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
        validateRawValue(of: .action,           against: 28)
        validateRawValue(of: .adventure,        against: 12)
        validateRawValue(of: .animation,        against: 16)
        validateRawValue(of: .comedy,           against: 35)
        validateRawValue(of: .crime,            against: 80)
        validateRawValue(of: .documentary,      against: 99)
        validateRawValue(of: .drama,            against: 18)
        validateRawValue(of: .family,           against: 10751)
        validateRawValue(of: .fantasy,          against: 14)
        validateRawValue(of: .foreign,          against: 10769)
        validateRawValue(of: .history,          against: 36)
        validateRawValue(of: .horror,           against: 27)
        validateRawValue(of: .music,            against: 10402)
        validateRawValue(of: .mystery,          against: 9648)
        validateRawValue(of: .romance,          against: 10749)
        validateRawValue(of: .scienceFiction,   against: 878)
        validateRawValue(of: .tvMovie,          against: 10770)
        validateRawValue(of: .thriller,         against: 53)
        validateRawValue(of: .war,              against: 10752)
        validateRawValue(of: .western,          against: 37)
    }
    
    func testNames() {
        validateName(of: .action,               against: "Action")
        validateName(of: .adventure,            against: "Adventure")
        validateName(of: .animation,            against: "Animation")
        validateName(of: .comedy,               against: "Comedy")
        validateName(of: .crime,                against: "Crime")
        validateName(of: .documentary,          against: "Documentary")
        validateName(of: .drama,                against: "Drama")
        validateName(of: .family,               against: "Family")
        validateName(of: .fantasy,              against: "Fantasy")
        validateName(of: .foreign,              against: "Foreign")
        validateName(of: .history,              against: "History")
        validateName(of: .horror,               against: "Horror")
        validateName(of: .music,                against: "Music")
        validateName(of: .mystery,              against: "Mystery")
        validateName(of: .romance,              against: "Romance")
        validateName(of: .scienceFiction,       against: "Science Fiction")
        validateName(of: .thriller,             against: "Thriller")
        validateName(of: .tvMovie,              against: "TV Show")
        validateName(of: .war,                  against: "War")
        validateName(of: .western,              against: "Western")
    }
    
    // MARK: - Private Helpers
    
    private func validateRawValue(of genre: MovieGenre, against value: Int) {
        XCTAssert(genre.rawValue == value)
    }
    
    private func validateName(of genre: MovieGenre, against name: String) {
        XCTAssert(genre.name == name)
    }
    
}
