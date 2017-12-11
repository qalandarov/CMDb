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
        guard !isCancelled else { return }
        super.start()
        network.movieDetails(id: movieID) { [weak self] result in
            guard let `self` = self, !self.isCancelled else { return }
            self.result = result
            self.finish()
        }
    }

    override func cancel() {
        network.cancel()
        super.cancel()
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
