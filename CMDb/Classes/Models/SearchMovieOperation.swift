//
//  SearchMovieOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 2/2/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class SearchMovieOperation: NetworkOperation<Search<Movie>> {
    
    var searchResult: Search<Movie>? { return result?.value }
    
    private var query: String
    private var page: Int
    
    required init(query: String, page: Int) {
        self.query = query
        self.page = page
        super.init()
    }
    
    override func start() {
        guard !isCancelled else { return }
        super.start()
        network.searchMovie(query: query, page: page, completion: handleCompletion)
    }
    
}