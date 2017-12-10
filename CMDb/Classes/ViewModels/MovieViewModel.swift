//
//  MovieViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/19/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

struct MovieViewModel: ImageDownloadable {
    let id: Int
    let title: String
    let releaseDate: String
    let releaseYear: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let genres: String?
    var casts: [CastViewModel]?
    
    var hasCast: Bool {
        guard let casts = casts, !casts.isEmpty else {
            return false
        }
        return true
    }
    
    /// "title + (YYYY)" format
    var titleAndYear: String {
        return "\(title) (\(releaseYear))"
    }
    
    init(with movie: Movie) {
        id              = movie.id
        title           = movie.title
        releaseDate     = movie.releaseDate
        releaseYear     = movie.releaseYear
        posterPath      = movie.posterPath
        backdropPath    = movie.backdropPath
        overview        = movie.overview
        genres          = movie.genres?.map({ $0.name }).joined(separator: ", ")
        casts           = movie.credits?.cast.flatMap(CastViewModel.init)
    }
}

// MARK: - Networking

extension MovieViewModel {
    mutating func fetchDetails(completion: @escaping VoidCompletion) {
        guard casts == nil else {
            completion()
            return
        }
        
        let op = MovieDetailsDownloadOperation(movieID: id)
        OperationQueue().addOperations([op], waitUntilFinished: true)
        
        casts = op.movie?.credits?.cast.flatMap(CastViewModel.init)
        
        OperationQueue.main.addOperation {
            completion()
        }
    }
}
