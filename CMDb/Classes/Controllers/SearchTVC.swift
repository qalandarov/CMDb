//
//  SearchTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

protocol SearchTVCDelegate: class {
    func didSelect(_ movie: Movie)
}

class SearchTVC: UITableViewController {
    
    weak var delegate: SearchTVCDelegate?
    
    var query = "" {
        didSet {
            if oldValue != query {
                searchIfNeeded()
            }
        }
    }
    
    private lazy var searchResults: [String : Search<Movie>] = [:]
    
    private var movies: [Movie]? {
        return searchResults[query]?.results
    }
    
    private var shouldShowLoading = false
    
    private lazy var network = NetworkEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide extra gap under the search bar
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.prefetchDataSource = self
        
        // Hide the empty cells
        let invisibleFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableView.tableFooterView = UIView(frame: invisibleFrame)
    }
    
    private func searchIfNeeded() {
        shouldShowLoading = !query.isEmpty
        
        if !query.isEmpty {
            searchNext()
        }
        
        tableView.reloadData()
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
        deleteLoadingCell()
        alert(error.string)
    }
    
    private func process(_ search: Search<Movie>, for query: String) {
        if !search.isValid || !search.hasNextPage {
            deleteLoadingCell()
            
            if !search.isValid {
                alert("No movies found for: \(query)")
            }
        }
        
        let existingSearch = searchResults[query]?.combined(with: search) ?? search
        searchResults[query] = existingSearch
        tableView.reloadData()
    }
    
    private func deleteLoadingCell() {
        shouldShowLoading = false
        tableView.reloadData()
    }
    
    private func alert(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
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
            return tableView.dequeueReusableCell(for: indexPath) as LoadingTableCell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieTableCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies?[indexPath.row] else {
            return
        }
        
        delegate?.didSelect(movie)
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
