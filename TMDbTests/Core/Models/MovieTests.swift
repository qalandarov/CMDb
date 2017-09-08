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
        XCTAssert(movie.genres! == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
    func testMovie_Details() {
        guard let movie: Movie = decodable(from: "movie-details") else {
            assertionFailure("couldn't decode a movie")
            return
        }
        
        // Basic details
        XCTAssert(movie.id == 460790)
        XCTAssert(movie.title == "Starship Troopers: Traitor of Mars")
        XCTAssert(movie.originalTitle == "Starship Troopers: Traitor of Mars")
        XCTAssert(movie.releaseDate == "2017-08-21")
        XCTAssert(movie.posterPath == "/dzqEq8Jbvb5SYGoYPqLyIRrt6Cm.jpg")
        XCTAssert(movie.backdropPath == "/u3hiCBwJ2yGCiJb3kOoqXThTQ7Z.jpg")
        XCTAssert(movie.genres! == [.action, .animation, .scienceFiction])
        XCTAssert(movie.voteCount == 33)
        XCTAssert(movie.voteAvg == 5.9)
        XCTAssert(movie.popularity == 43.270812)
        XCTAssert(movie.overview == "Federation trooper Johnny Rico is blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
        
        // Credits
        XCTAssertNil(movie.credits)
        
        // Images
        let images = movie.images!
        XCTAssert(images.posters.count == 4)
        XCTAssert(images.posters[0].filePath == "/dzqEq8Jbvb5SYGoYPqLyIRrt6Cm.jpg")
        XCTAssert(images.posters[1].filePath == "/xvLjHhlqouwqaXtah8SKv6JxOZN.jpg")
        XCTAssert(images.posters[2].filePath == "/JVyw64f6NUpGTdBibBA2f1TsNV.jpg")
        XCTAssert(images.posters[3].filePath == "/oZynvwkA2S80jOBbXH1Akhd7khn.jpg")
        XCTAssert(images.backdrops.count == 4)
        XCTAssert(images.backdrops[0].filePath == "/u3hiCBwJ2yGCiJb3kOoqXThTQ7Z.jpg")
        XCTAssert(images.backdrops[1].filePath == "/27nKWPZFGcCDWYJkCwrJOzjD26q.jpg")
        XCTAssert(images.backdrops[2].filePath == "/nqyORVM3MzHvhWax4QqV4HkZUQh.jpg")
        XCTAssert(images.backdrops[3].filePath == "/iIl26f9PTOwjFthNwiODoaMekAM.jpg")
        
        // Video
        let videos = movie.videos!
        XCTAssert(videos.videos.count == 1)
        XCTAssert(videos.videos.first!.key == "8R0yLRoevnA")
        XCTAssert(videos.videos.first!.site == "YouTube")
        XCTAssert(videos.videos.first!.isYoutube == true)
        XCTAssert(videos.videos.first!.url!.absoluteString == "https://youtu.be/8R0yLRoevnA")
    }
    
    func testMovie_NilPoster() {
        guard let movie: Movie = decodable(from: "movie-null-poster") else { return }
        
        XCTAssert(movie.id == 268)
        XCTAssert(movie.title == "Batman")
        XCTAssert(movie.originalTitle == "Batman")
        XCTAssert(movie.releaseDate == "1989-06-23")
        XCTAssert(movie.posterPath == nil)
        XCTAssert(movie.backdropPath == "/2blmxp2pr4BhwQr74AdCfwgfMOb.jpg")
        XCTAssert(movie.genres! == [.fantasy, .action])
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
        XCTAssert(movie.genres! == [.fantasy, .action])
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
        XCTAssert(movie.genres! == [.fantasy, .action])
        XCTAssert(movie.voteCount == 2012)
        XCTAssert(movie.voteAvg == 7)
        XCTAssert(movie.popularity == 11.032138)
        XCTAssert(movie.overview == "The Dark Knight of Gotham City blah-blah-blah...")
        XCTAssert(movie.isVideo == false)
    }
    
}
