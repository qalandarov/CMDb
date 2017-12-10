//
//  HomeTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel

protocol MoviePresentable {
    func didSelectMovie(_ viewModel: MovieViewModel)
}

extension HomeTVC: MoviePresentable {
    func didSelectMovie(_ viewModel: MovieViewModel) {
        selectedVM = viewModel
    }
}

class HomeTVC: UITableViewController, SegueHandlerType {
    
    private var selectedVM: MovieViewModel? {
        didSet {
            performSegue(.movieDetails, sender: self)
        }
    }
    
    private lazy var searchController: UISearchController? = {
        guard let searchTVC: SearchTVC = Storyboard.search.viewController() else {
            return nil
        }

        searchTVC.delegate = self
        definesPresentationContext = true

        let controller = UISearchController(searchResultsController: searchTVC)
        controller.dimsBackgroundDuringPresentation = true
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = searchTVC
        controller.searchBar.tintColor = .white
        controller.searchBar.barStyle = .black

        return controller
    }()
    
    lazy var vm = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fetchAllSections { [weak self] in
            self?.refreshTableView()
        }
        
        // Adding the search bar and hiding it behind the nav bar
        tableView.tableHeaderView = searchController?.searchBar
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    private func refreshTableView() {
        let indexSet = IndexSet(integer: 0)
        tableView.beginUpdates()
        tableView.reloadSections(indexSet, with: .none)
        tableView.endUpdates()
    }
    
    // MARK: - Navigation
    
    enum SegueIdentifier: String, SegueValidatable {
        case movieDetails
        
        var expectedType: UIViewController.Type {
            switch self {
            case .movieDetails: return MovieDetailsTVC.self
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segueIdentifier(for: segue) else { return }
        
        switch segueID {
        case .movieDetails:
            guard
                let vm = selectedVM,
                let detailsVC = segueID.destination(from: segue, as: MovieDetailsTVC.self)
                else {
                    return
            }

            detailsVC.vm = vm
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfSections
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieViewModels = vm.movieViewModels(at: indexPath)
        
        guard indexPath.row > 0 else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as FeaturedMoviesTableCell
            cell.configure(with: movieViewModels, presentor: self)
            return cell
        }
        
        // prepare the rest
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieSectionTableCell
        cell.configure(with: movieViewModels, title: vm.title(at: indexPath), presentor: self)
        return cell
    }
    
}

extension HomeTVC: SearchTVCDelegate {
    func didSelect(_ query: String) {
        searchController?.searchBar.text = query
        guard let searchTVC = searchController?.searchResultsController as? SearchTVC else { return }
        searchTVC.query = query
    }
    
    func didSelect(_ viewModel: MovieViewModel) {
        selectedVM = viewModel
    }
}

extension HomeTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}
