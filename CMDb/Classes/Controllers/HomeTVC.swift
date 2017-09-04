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
    case topRated
    case popular
    
    var title: String {
        switch self {
        case .topRated:     return "Top Rated >"
        case .popular:      return "Popular >"
        }
    }
    
    var urls: [URL]? {
        switch self {
        case .topRated:     return urls(from: MovieSection.topRatedMovies)
        case .popular:      return urls(from: MovieSection.popularMovies)
        }
    }
    
    private func urls(from movies: [Movie]?) -> [URL]? {
        return movies?.flatMap({ $0.backdropURL(width: .w500) })
    }
    
    static var all: [MovieSection] {
        return [.topRated, .popular]
    }
    
    static var topRatedMovies: [Movie]?
    static var popularMovies: [Movie]?
}

class HomeTVC: UITableViewController {

    @IBOutlet weak var bgCarousel: iCarousel!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var placeholderView: UIView!
    
    private var movies: [Movie]? {
        didSet {
            carousel.reloadData()
            bgCarousel.reloadData()
            carousel.currentItemIndex = Int(moviesCount / 2)
        }
    }
    
    private var moviesCount: Int {
        return movies?.count ?? 0
    }
    
    private let network = NetworkEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgCarousel.bounces = false
        bgCarousel.delegate = self
        bgCarousel.dataSource = self
        
        carousel.type = .coverFlow
        carousel.delegate = self
        carousel.dataSource = self
        
        placeholderView.backgroundColor = .clear
        
        let invisibleFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableView.tableFooterView = UIView(frame: invisibleFrame)
        
        networkCall()
        fetchAllSections()
    }
    
    private func networkCall() {
        network.movies(type: .upcoming) { [weak self] result in
            switch result {
            case .success(let search):
                self?.movies = search.results.filter { $0.posterPath != nil }
            case .failure(let error):
                print("error: \(error.string)")
            }
        }
    }
    
    func fetchAllSections() {
        movies(type: .toprated) { MovieSection.topRatedMovies = $0.value }
        movies(type: .popular)  { MovieSection.popularMovies = $0.value }
    }
    
    private func movies(type: MovieSectionType, completion: @escaping ResultCompletionMovies) {
        network.movies(type: type) { [weak self] result in
            switch result {
            case .success(let search):
                let movies = search.results.filter { $0.backdropPath != nil }
                completion(.success(movies))
                self?.tableView.reloadData()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieSection.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSectionTableCell", for: indexPath) as! MovieSectionTableCell
        
        let section = MovieSection(rawValue: indexPath.row)
        cell.configure(with: section)
        
        return cell
    }
    
}

extension HomeTVC: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return moviesCount
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let bg = carousel == bgCarousel
        let frame = bg ? carousel.frame : placeholderView.frame
        let posterView = view as? UIImageView ?? UIImageView(frame: frame)
        posterView.setPosterImage(with: movies![index])
        return posterView
    }
}

extension HomeTVC: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
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
