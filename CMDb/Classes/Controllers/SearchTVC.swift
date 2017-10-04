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

    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count + 1 // "loading..." cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < movies.count else {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingTableCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieTableCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
}

extension SearchTVC: UISearchControllerDelegate {
    
}

extension SearchTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
    }
}
