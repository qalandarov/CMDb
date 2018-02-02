//
//  MovieDetailsDownloadOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieDetailsDownloadOperation: NetworkOperation<Movie> {
    
    var movie: Movie? { return result?.value }
    
    private var movieID: Int
    
    required init(movieID: Int) {
        self.movieID = movieID
        super.init()
    }
    
    override func start() {
        guard !isCancelled else { return }
        super.start()
        network.movieDetails(id: movieID, completion: handleCompletion)
    }
}
