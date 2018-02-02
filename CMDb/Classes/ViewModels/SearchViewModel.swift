//
//  SearchViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 12/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class SearchViewModel {
    
    var refreshUI: (() -> ())?
    var errorAction: ((String) -> ())?
    
    var shouldShowLoading = false
    var query = "" {
        didSet {
            shouldShowLoading = !query.isEmpty
            
            if oldValue != query && !query.isEmpty {
                if movies == nil {
                    searchNextPage()
                }
            }
            
            refreshUI?()
        }
    }
    
    lazy var searchResults: [String: Search<Movie>] = [:]
    
    var previousSearches: [String] {
        return searchResults.keys.map { $0 }
    }
    
    var currentSearch: Search<Movie>? {
        get { return searchResults[query] }
        set { searchResults[query] = newValue }
    }

    var movies: [Movie]? {
        return currentSearch?.results
    }
    
    // MARK: - Functions
    
    func searchNextPage() {
        let currentPage = currentSearch?.page ?? 0
        let nextPage = currentPage + 1
        search(query, page: nextPage)
    }
    
    func resetSearch() {
        query = ""
        OperationQueue().cancelAllOperations()
    }
}

// MARK: - Networking

extension SearchViewModel {
    
    private func search(_ query: String, page: Int = 0) {
        let op = SearchMovieOperation(query: query, page: page)
        
        let blockOp = BlockOperation {
            guard !op.isCancelled, let result = op.result else { return }
            
            switch result {
            case .success(let search):
                self.process(search, for: query)
            case .failure(let error):
                self.shouldShowLoading = false
                self.errorAction?(error.string)
            }
        }
        
        blockOp.addDependency(op)
        
        OperationQueue().addOperation(op)
        OperationQueue.main.addOperation(blockOp)
    }
    
    private func process(_ search: Search<Movie>, for query: String) {
        guard search.isValid else {
            shouldShowLoading = false
            errorAction?("No movies found for: \(query)")
            return
        }
        
        currentSearch = currentSearch?.combined(with: search) ?? search
        refreshUI?()
    }
    
}

// MARK: - Table view helpers

enum CellType {
    case loading
    case movie(Movie)
    case prevSearch(String)
}

enum CellSelectionType {
    case void
    case string(String)
    case movieVM(MovieViewModel)
}

extension SearchViewModel {
    
    var numberOfRows: Int {
        guard !query.isEmpty else {
            return previousSearches.count
        }
        
        let movieRows = movies?.count ?? 0
        let loadingRow = shouldShowLoading ? 1 : 0
        return movieRows + loadingRow
    }
    
    func cellType(for indexPath: IndexPath) -> CellType {
        if query.isEmpty {
            return .prevSearch(previousSearches[indexPath.row])
        }
        
        if let movies = self.movies, indexPath.row < movies.count {
            return .movie(movies[indexPath.row])
        }
        
        searchNextPage()
        return .loading
    }
    
    func cellSelectionType(for indexPath: IndexPath) -> CellSelectionType {
        if query.isEmpty {
            let searchText = previousSearches[indexPath.row]
            query = searchText
            return .string(searchText)
        }
        
        if let movie = movies?[indexPath.row] {
            return .movieVM(MovieViewModel(with: movie))
        }
        
        return .void
    }
    
}
