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
    func didSelect(_ query: String)
    func didSelect(_ viewModel: MovieViewModel)
}

class SearchTVC: UITableViewController {
    
    private lazy var viewModel = SearchViewModel()
    weak var delegate: SearchTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.refreshUI = tableView.reloadData
        viewModel.errorAction = alert
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.resetSearch()
    }
    
    func setupUI() {
        // Hide extra gap under the search bar
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        // Hide the empty cells
        tableView.tableFooterView = UIView()
        
        tableView.prefetchDataSource = self
        
        // Prevent autolayout bugs
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

// MARK: - Search bar delegate

extension SearchTVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.isHidden = false
        viewModel.query = searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.resetSearch()
        }
    }
}

// MARK: - Table view data source

extension SearchTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return processedCell(from: tableView, at: indexPath)
    }
}

// MARK: - Table view delegate

extension SearchTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = viewModel.cellSelectionType(for: indexPath)
        
        switch type {
        case .void:
            break
            
        case .movieVM(let movieVM):
            delegate?.didSelect(movieVM)
            
        case .string(let query):
            viewModel.query = query
            delegate?.didSelect(query)
        }
    }
}

// MARK: - Prefetching data source

extension SearchTVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { processedCell(from: tableView, at: $0) }
    }
}

// MARK: - Cell generation helpers

extension SearchTVC {
    @discardableResult
    private func processedCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.cellType(for: indexPath)
        
        switch type {
        case .loading:
            viewModel.searchNextPage()
            return loadingCell(for: indexPath)
        case .movie(let movie):
            return movieCell(for: indexPath, with: movie)
        case .prevSearch(let searchText):
            return prevSearchCell(for: indexPath, with: searchText)
        }
    }
    
    private func prevSearchCell(for indexPath: IndexPath, with searchText: String) -> PreviousSearchCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as PreviousSearchCell
        cell.searchText = searchText
        return cell
    }
    
    private func loadingCell(for indexPath: IndexPath) -> LoadingTableCell {
        return tableView.dequeueReusableCell(for: indexPath)
    }
    
    private func movieCell(for indexPath: IndexPath, with movie: Movie) -> MovieTableCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieTableCell
        cell.configure(with: movie)
        return cell
    }
}
