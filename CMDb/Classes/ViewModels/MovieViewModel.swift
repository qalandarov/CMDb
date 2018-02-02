//
//  MovieViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/19/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class MovieViewModel: ImageDownloadable {
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
    func fetchDetailsIfNeeded(completion: @escaping VoidCompletion) {
        guard casts == nil else {
            completion()
            return
        }
        
        let op = MovieDetailsDownloadOperation(movieID: id)
        
        let blockOp = BlockOperation {
            self.casts = op.movie?.credits?.cast.flatMap(CastViewModel.init)
            completion()
        }
        
        blockOp.addDependency(op)
        
        OperationQueue().addOperation(op)
        OperationQueue.main.addOperation(blockOp)
    }
}
