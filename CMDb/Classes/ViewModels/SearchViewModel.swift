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
    case finished(SearchMO)
}

class SearchViewModel {
    
    var query = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            } else {
                searchIfAble(query)
            }
        }
    }
    
    let refreshUI: (() -> ())
    let errorAction: ((String) -> ())
    
    private var previousSearches: [String] = []
    private var currentSearch: SearchMO? = nil
    private lazy var workerQueue = OperationQueue()
    
    private var movies: [MovieMO]? {
        return currentSearch?.allMovies
    }
    
    init(refreshUI: @escaping (() -> ()), errorAction: @escaping ((String) -> ())) {
        self.refreshUI = refreshUI
        self.errorAction = errorAction
        previousSearches = DBManager.shared.latestSearchQueries()
    }
    
    
    private func nextPage(for query: String) -> Int {
        // If we started a new search start from 1
        guard let search = currentSearch, search.query == query else {
            return 1
        }
        return Int(search.page) + 1
    }

    
    // MARK: - State manipulations
    
    func searchNextPage() {
        searchIfAble(query)
    }
    
    func resetSearch() {
        state = .reset
    }
    private var state: SearchState = .reset {
        didSet {
            switch state {
            case .reset:
                currentSearch = nil
                workerQueue.cancelAllOperations()
            case .searching(let query):
                search(query)
            case .error(let errorMsg):
                errorAction(errorMsg)
            case .finished(let search):
                currentSearch = search
                previousSearches = DBManager.shared.latestSearchQueries()
            }
            
            refreshUI()
        }
    }
}

// MARK: - Networking / DB

extension SearchViewModel {
    
    private func searchIfAble(_ query: String) {
        switch state {
        case .searching:    break // ignoring duplicate calls
        default:            state = .searching(query)
        }
    }
    
    private func search(_ query: String) {
        let nextPage = self.nextPage(for: query)
        
        if let searchObject = DBManager.shared.search(for: query) {
            if currentSearch?.query == searchObject.query, searchObject.page >= nextPage {
                state = .finished(searchObject)
                return
            }
        }
        
        let op = SearchMovieOperation(query: query, page: nextPage)
        
        let blockOp = BlockOperation { [weak self] in
            guard !op.isCancelled, let searchResult = op.result else { return }
            
            switch searchResult {
            case .success(let search):
                self?.state = .finished(search)
            case .failure(let error):
                self?.state = .error(error.string)
            }
        }
        
        blockOp.addDependency(op)
        
        workerQueue.addOperation(op)
        OperationQueue.main.addOperation(blockOp)
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
