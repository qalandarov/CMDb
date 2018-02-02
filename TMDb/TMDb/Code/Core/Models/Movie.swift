//
//  Movie.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

let dateFormatter = DateFormatter() // creating a global one as it's too expensive to create

import Foundation

/*
 *  Assuming that only posterPath and backdropPath properties are optional
 *  and assuming that the data types are correct
 */

extension Movie: Equatable {
    public static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct Movie: Decodable, ImageDownloadable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let releaseDate: Date
    public let posterPath: String?
    public let backdropPath: String?
    public let voteCount: Int
    public let voteAvg: CGFloat
    public let popularity: CGFloat
    public let overview: String
    public let isVideo: Bool
    public let credits: Credits?
    public let images: Artwork?
    public let videos: Trailer?
    
    let genreIDs: [Int]?
    let genreObjects: [GenreObject]?
    
    public var genres: [MovieGenre]? {
        guard let ids = genreIDs ?? genreObjects?.flatMap({ $0.id }) else {
            return nil
        }
        return ids.flatMap { MovieGenre(rawValue: $0) }
    }
    
    public var releaseYear: String {
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: releaseDate)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle  = "original_title"
        case releaseDate    = "release_date"
        case posterPath     = "poster_path"
        case backdropPath   = "backdrop_path"
        case voteCount      = "vote_count"
        case voteAvg        = "vote_average"
        case popularity
        case overview
        case isVideo        = "video"
        case credits
        case images
        case videos
        
        case genreIDs       = "genre_ids"
        case genreObjects   = "genres"
    }
}
