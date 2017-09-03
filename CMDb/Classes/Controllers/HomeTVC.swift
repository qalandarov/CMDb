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
    }
    
    private func networkCall() {
        network.searchMovie(query: "batman") { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let search):
                    self?.movies = search.results.filter { $0.posterPath != nil }
                case .failure(let error):
                    print("error: \(error.string)")
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "MovieSectionTableCell", for: indexPath)
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
        posterView.setImage(with: movies![index])
        return posterView
    }
}

extension HomeTVC: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
    }
}

extension UIImageView {
    func setImage(with movie: Movie) {
        kf.cancelDownloadTask()
        let url = movie.posterURL(width: .w185)
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
