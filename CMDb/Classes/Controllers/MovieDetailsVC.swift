//
//  MovieDetailsVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/6/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieDetailsVC: UIViewController, SegueHandlerType {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    private var castCollectionVC: ProfilesCollectionVC?
    private let network = NetworkEngine()
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        fetchDetails()
    }
    
    private func prepareUI() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title + " (\(movie.releaseYear))" // title + (YYYY)
        genreLabel.text = movie.genres?.map({ $0.name }).joined(separator: ", ")
        
        bgImageView.setPosterImage(with: movie)
        imageView.setBackdropImage(with: movie)
        
        if let casts = movie.credits?.cast {
            castCollectionVC?.casts = casts
        }
    }
    
    private func fetchDetails() {
        guard let id = movie?.id else { return }
        
        network.movieDetails(id: id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.prepareUI()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Navigation
    
    enum SegueIdentifier: String, SegueValidatable {
        case casts
        
        var expectedType: UIViewController.Type {
            switch self {
            case .casts: return ProfilesCollectionVC.self
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segueIdentifier(for: segue) else { return }
        
        switch segueID {
        case .casts:
            castCollectionVC = segueID.destination(from: segue, as: ProfilesCollectionVC.self)
        }
    }
    
}

