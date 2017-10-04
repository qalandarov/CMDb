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
    
    var urls: [URL]? {
        switch self {
        case .upcoming:     return urls(from: MovieSection.upcomingMovies)
        case .topRated:     return urls(from: MovieSection.topRatedMovies)
        case .popular:      return urls(from: MovieSection.popularMovies)
        }
    }
    
    private func urls(from movies: [Movie]?) -> [URL]? {
        return movies?.flatMap({ $0.backdropURL() })
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllSections()
        
        let invisibleFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableView.tableFooterView = UIView(frame: invisibleFrame)
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
                self?.tableView.reloadData()
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
        guard indexPath.row > 0 else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as FeaturedMoviesTableCell
            
            if let movies = MovieSection.upcomingMovies {
                cell.configure(with: movies, presentor: self)
            }
            
            return cell
        }
        
        // prepare the rest
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieSectionTableCell
        
        let section = MovieSection(rawValue: indexPath.row)
        cell.configure(with: section)
        
        return cell
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
        kf.setImage(with: url)
    }
}
