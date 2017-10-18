//
//  MovieDetailsDownloadOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieDetailsDownloadOperation: AsyncOperation {
    private lazy var network = NetworkEngine()
    private var result: Result<Movie>?
    
    private var movieID = 0
    
    required init(movieID: Int) {
        super.init()
        
        guard movieID > 0 else {
            assertionFailure("Invalid movie id is passed")
            cancel()
            return
        }
        
        self.movieID = movieID
    }
    
    override func start() {
        network.movieDetails(id: movieID) { [weak self] result in
            self?.result = result
            self?.state = .finished
        }
    }
}

extension MovieDetailsDownloadOperation {
    var movie: Movie? {
        return result?.value
    }
    
    var error: TMDb.Error? {
        return result?.error
    }
}
