//
//  SearchTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class SearchTVC: UITableViewController {
    
    var query = "robin" {
        didSet {
            searchNext()
        }
    }
    
    private lazy var searchResults: [String : Search<Movie>] = [:]
    
    private var movies: [Movie]? {
        return searchResults[query]?.results
    }
    
    private var shouldShowLoading = true
    
    private lazy var network = NetworkEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        let invisibleFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableView.tableFooterView = UIView(frame: invisibleFrame)
    }
    
    private func searchNext() {
        let currentPage = searchResults[query]?.page ?? 0
        let nextPage = currentPage + 1
        search(query, page: nextPage)
    }
    
    private func search(_ query: String, page: Int) {
        network.searchMovie(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let search):
                self?.process(search, for: query)
            case .failure(let error):
                self?.process(error)
            }
        }
    }
    
    private func process(_ error: TMDb.Error) {
        print(error.string)
        deleteLoadingCell()
    }
    
    private func process(_ search: Search<Movie>, for query: String) {
        guard search.isValid && search.hasNextPage else {
            deleteLoadingCell()
            return
        }
        
        let startingPoint = searchResults[query]?.results.count ?? 0
        let existingSearch = searchResults[query]?.combined(with: search) ?? search
        
        searchResults[query] = existingSearch
        
        insertRows(range: startingPoint..<existingSearch.results.count)
    }
    
    private func insertRows(range: CountableRange<Int>) {
        let indexPaths = range.map { IndexPath(row: $0, section: 0) }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    private func deleteLoadingCell() {
        shouldShowLoading = false
        
        let lastRow = movies?.count ?? 1
        let indexPath = IndexPath(row: lastRow, section: 0)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let movieRows = movies?.count ?? 0
        let loadingRows = shouldShowLoading ? 1 : 0
        return movieRows + loadingRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return processedCell(from: tableView, at: indexPath)
    }
    
    @discardableResult
    private func processedCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let movies = self.movies, indexPath.row < movies.count else {
            searchNext()
            return tableView.dequeueReusableCell(withIdentifier: "LoadingTableCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieTableCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
}

extension SearchTVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            processedCell(from: tableView, at: $0)
        }
    }
}

extension SearchTVC: UISearchControllerDelegate {
    
}

extension SearchTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
    }
}
