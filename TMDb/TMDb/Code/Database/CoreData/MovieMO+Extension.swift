//
//  MovieMO+Extension.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/6/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import CoreData

extension MovieMO {
    
    @discardableResult
    static func insertOrUpdate(_ movie: Movie, in context: NSManagedObjectContext) -> MovieMO {
        if let movieObject = MovieMO.existing(with: movie.id, in: context) {
            movieObject.modify(with: movie, in: context)
            return movieObject
        }
        
        return MovieMO(with: movie, in: context)
    }
    
    private static func existing(with id: Int, in context: NSManagedObjectContext) -> MovieMO? {
        let predicate = NSPredicate(format: "id == %d", id)
        let movies = MovieMO.fetch(predicate: predicate, from: context)
        return movies?.first
    }
    
    private convenience init(with movie: Movie, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int64(movie.id)
        self.modify(with: movie, in: context)
    }
    
    private func modify(with movie: Movie, in context: NSManagedObjectContext) {
        
        title           = movie.title
        originalTitle   = movie.originalTitle
        overview        = movie.overview
        backdropPath    = movie.backdropPath
        posterPath      = movie.posterPath
        releaseDate     = movie.releaseDate
        isVideo         = movie.isVideo
        popularity      = Float(movie.popularity)
        voteAvg         = Float(movie.voteAvg)
        voteCount       = Int16(movie.voteCount)
    }
    
}
