//
//  Movie.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

/*
 *  Assuming that only posterPath and backdropPath properties are optional
 *  and assuming that the data types are correct
 */

public struct Movie: Decodable, ImageDownloadable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let releaseDate: String
    public let posterPath: String?
    public let backdropPath: String?
    public let genres: [MovieGenre]
    public let voteCount: Int
    public let voteAvg: CGFloat
    public let popularity: CGFloat
    public let overview: String
    public let isVideo: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle  = "original_title"
        case releaseDate    = "release_date"
        case posterPath     = "poster_path"
        case backdropPath   = "backdrop_path"
        case genres         = "genre_ids"
        case voteCount      = "vote_count"
        case voteAvg        = "vote_average"
        case popularity
        case overview
        case isVideo        = "video"
    }
}
