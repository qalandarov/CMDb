//
//  MovieSectionDownloadOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class MovieSectionDownloadOperation: NetworkOperation<Search<Movie>> {
    
    var movies: [MovieViewModel]? {
        return result?.value?.results.map(MovieViewModel.init)
    }
    
    private var section: MovieSectionType
    
    required init(section: MovieSectionType) {
        self.section = section
        super.init()
    }
    
    override func start() {
        guard !isCancelled else { return }
        super.start()
        network.movies(type: section, completion: handleCompletion)
    }
}
