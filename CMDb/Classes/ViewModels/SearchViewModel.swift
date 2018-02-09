//
//  SearchViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 12/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

enum SearchState {
    case reset
    case searching(String)
    case error(String)
    case finished(Search<Movie>)
}

class SearchViewModel {
    
    let refreshUI: (() -> ())
    let errorAction: ((String) -> ())
    
    init(refreshUI: @escaping (() -> ()), errorAction: @escaping ((String) -> ())) {
        self.refreshUI = refreshUI
        self.errorAction = errorAction
    }
    
    var query = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            } else {
                searchIfAble(query)
            }
        }
    }
    
    private lazy var workerQueue = OperationQueue()
    
    private lazy var searchResults: [String: Search<Movie>] = [:]
    
    private lazy var previousSearches = DBManager.shared.latestSearchQueries()
    
    private var currentSearch: Search<Movie>? {
        get { return searchResults[query] }
        set { searchResults[query] = newValue }
    }
    
    // pages start from 1, so if the currentSearch is nil the page still starts from 1
    private var nextPage: Int {
        return (currentSearch?.page ?? 0) + 1
    }

    private var movies: [Movie]? {
        return currentSearch?.results
    }
    
    private var state: SearchState = .reset {
        didSet {
            switch state {
            case .reset:
                workerQueue.cancelAllOperations()
            case .searching(let query):
                search(query)
            case .error(let errorMsg):
                errorAction(errorMsg)
            case .finished(let search):
                // Combine "search" with the "currentSearch" or if nil set it as the "currentSearch"
                currentSearch = currentSearch?.combined(with: search) ?? search
                previousSearches = DBManager.shared.latestSearchQueries()
            }
            
            refreshUI()
        }
    }
    
    // MARK: - Functions
    
    func searchNextPage() {
        searchIfAble(query)
    }
    
    func resetSearch() {
        state = .reset
    }
}

// MARK: - Networking

extension SearchViewModel {
    
    private func searchIfAble(_ query: String) {
        switch state {
        case .searching:    break // ignoring duplicate calls
        default:            state = .searching(query)
        }
    }
    
    private func search(_ query: String) {
        let op = SearchMovieOperation(query: query, page: nextPage)
        
        let blockOp = BlockOperation { [weak self] in
            guard !op.isCancelled, let searchResult = op.result else { return }
            self?.process(searchResult, for: query)
        }
        
        blockOp.addDependency(op)
        
        workerQueue.addOperation(op)
        OperationQueue.main.addOperation(blockOp)
    }
    
    private func process(_ searchResult: Result<Search<Movie>>, for query: String) {
        switch searchResult {
        case .success(let search):
            if search.isValid {
                state = .finished(search)
            } else {
                state = .error("No movies found for: \(query)")
            }
        case .failure(let error):
            state = .error(error.string)
        }
    }
    
}

// MARK: - Table view helpers

enum CellType {
    case loading
    case movieVM(MovieViewModel)
    case prevSearch(String)
}

extension SearchViewModel {
    
    var numberOfRows: Int {
        let movieRows = movies?.count ?? 0
        let hasNextPage = currentSearch?.hasNextPage ?? false
        
        switch state {
        case .reset:        return previousSearches.count
        case .error:        return movieRows
        case .searching:    return movieRows + 1 // show loading while searching
        case .finished:     return movieRows + (hasNextPage ? 1 : 0) // show the loading cell if there're more results
        }
    }
    
    func cellType(for indexPath: IndexPath) -> CellType {
        switch state {
        case .reset:
            return .prevSearch(previousSearches[indexPath.row])
        default:
            if let movies = self.movies, indexPath.row < movies.count {
                let movie = movies[indexPath.row]
                return .movieVM(MovieViewModel(with: movie))
            }
            
            return .loading
        }
    }
    
}
