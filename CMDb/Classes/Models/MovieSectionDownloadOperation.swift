//
//  MovieSectionDownloadOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class MovieSectionDownloadOperation: AsyncOperation {
    private lazy var network = NetworkEngine()
    private var result: Result<Search<Movie>>?
    
    var section: MovieSectionType
    
    required init(section: MovieSectionType) {
        self.section = section
        super.init()
    }
    
    override func start() {
        super.start()
        
        network.movies(type: section) { [weak self] result in
            self?.result = result
            self?.finish()
        }
    }
}

extension MovieSectionDownloadOperation {
    var movies: [MovieViewModel]? {
        return result?.value?.results.map(MovieViewModel.init)
    }
    
    var error: TMDb.Error? {
        return result?.error
    }
}
