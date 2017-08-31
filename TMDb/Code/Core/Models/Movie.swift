//
//  Movie.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
    let genreIDs: [Int]
    let voteCount: Int
    let voteAvg: Int
    let popularity: Double
    let overview: String
    let isVideo: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle  = "original_title"
        case releaseDate    = "release_date"
        case posterPath     = "poster_path"
        case backdropPath   = "backdrop_path"
        case genreIDs       = "genre_ids"
        case voteCount      = "vote_count"
        case voteAvg        = "vote_average"
        case popularity
        case overview
        case isVideo        = "video"
    }
}
