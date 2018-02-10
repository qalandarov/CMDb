//
//  SearchMovieOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 2/2/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class SearchMovieOperation: NetworkOperation<SearchMO> {
    
    var searchResult: SearchMO? { return result?.value }
    
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
        network.searchMovie(query: query, page: page, completion: complete)
    }
    
    private func complete(with result: Result<Search<Movie>>) {
        switch result {
        case .success(let search):
            if search.isValid {
                let searchObject = DBManager.shared.insertOrUpdate(search, for: query)
                handleCompletion(.success(searchObject))
            } else {
                let error = Error.general(errorMsg: "No movies found for: \(query)")
                handleCompletion(.failure(error))
            }
        case .failure(let error):
            handleCompletion(.failure(error))
        }
    }
    
}
