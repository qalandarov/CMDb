//
//  HomeTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel
import TMDb
import Kingfisher

enum MovieSection: Int {
    case upcoming
    case topRated
    case popular
    
    var title: String {
        switch self {
        case .upcoming:     return ""
        case .topRated:     return "Top Rated >"
        case .popular:      return "Popular >"
        }
    }
    
    var movies: [Movie]? {
        switch self {
        case .upcoming:     return MovieSection.upcomingMovies
        case .topRated:     return MovieSection.topRatedMovies
        case .popular:      return MovieSection.popularMovies
        }
    }
    
    static var all: [MovieSection] {
        return [.upcoming, .topRated, .popular]
    }
    
    static var upcomingMovies: [Movie]?
    static var topRatedMovies: [Movie]?
    static var popularMovies: [Movie]?
}

protocol MoviePresentable {
    func didSelectMovie(_ movie: Movie)
}

extension HomeTVC: MoviePresentable {
    func didSelectMovie(_ movie: Movie) {
        selectedMovie = movie
    }
}

class HomeTVC: UITableViewController, SegueHandlerType {
    
    private var selectedMovie: Movie? {
        didSet {
            performSegue(.movieDetails, sender: self)
        }
    }
    
    private let network = NetworkEngine()
    
    private lazy var searchController: UISearchController? = {
        guard let searchTVC: SearchTVC = Storyboard.search.viewController() else {
            return nil
        }

        searchTVC.delegate = self
        definesPresentationContext = true

        let controller = UISearchController(searchResultsController: searchTVC)
        controller.dimsBackgroundDuringPresentation = true
        controller.searchResultsUpdater = self
        controller.searchBar.tintColor = .white
        controller.searchBar.barStyle = .black

        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllSections()
        
        // Adding the search bar and hiding it behind the nav bar
        tableView.tableHeaderView = searchController?.searchBar
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    private func fetchAllSections() {
        movies(type: .upcoming) { MovieSection.upcomingMovies = $0.value?.filter { $0.posterPath != nil } }
        movies(type: .toprated) { MovieSection.topRatedMovies = $0.value?.filter { $0.backdropPath != nil } }
        movies(type: .popular)  { MovieSection.popularMovies  = $0.value?.filter { $0.backdropPath != nil } }
    }
    
    private func movies(type: MovieSectionType, completion: @escaping ResultCompletionMovies) {
        network.movies(type: type) { [weak self] result in
            switch result {
            case .success(let search):
                completion(.success(search.results))
                self?.refreshTableView()
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
                let movie = selectedMovie,
                let detailsVC = segueID.destination(from: segue, as: MovieDetailsTVC.self)
                else {
                    return
            }

            detailsVC.movie = movie
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieSection.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MovieSection(rawValue: indexPath.row)
        
        guard indexPath.row > 0 else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as FeaturedMoviesTableCell
            
            if let movies = section?.movies {
                cell.configure(with: movies, presentor: self)
            }
            
            return cell
        }
        
        // prepare the rest
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieSectionTableCell
        
        if let movies = section?.movies, let title = section?.title {
            cell.configure(with: movies, title: title, presentor: self)
        }
        
        return cell
    }
    
}

extension HomeTVC: SearchTVCDelegate {
    func didSelect(_ movie: Movie) {
        selectedMovie = movie
    }
}

extension HomeTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTVC = searchController.searchResultsController as? SearchTVC else { return }
        searchTVC.view.isHidden = false
        searchTVC.query = searchController.searchBar.text ?? ""
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let reuseID = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! T
    }
}

extension UIImageView {
    func setPosterImage(with movie: Movie, width: ImageWidth = .w185) {
        setImage(with: movie.posterURL(width: width))
    }
    
    func setBackdropImage(with movie: Movie, width: ImageWidth = .w500) {
        setImage(with: movie.backdropURL(width: width))
    }
    
    func setImage(with url: URL?) {
        kf.cancelDownloadTask()
        kf.indicatorType = .activity
        (kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        kf.setImage(with: url)
    }
}
