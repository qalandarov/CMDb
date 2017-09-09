//
//  MovieDetailsTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/9/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

enum TableSections: Int {
    case titleAndYear
    case overview
    case cast
    
    var rows: Int {
        return 1
    }
}

class MovieDetailsTVC: UITableViewController, SegueHandlerType {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var movie: Movie?
    private let network = NetworkEngine()
    private var castCollectionVC: ProfilesCollectionVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        fetchDetails()
        tableView.sectionHeaderHeight = 16
    }
    
    private func prepareUI() {
        guard let movie = movie else { return }
        
        imageView.setBackdropImage(with: movie)
        
        titleLabel.text = movie.title + " (\(movie.releaseYear))" // title + (YYYY)
        genreLabel.text = movie.genres?.map({ $0.name }).joined(separator: ", ")
        
        textView.text = movie.overview
        
        if let casts = movie.credits?.cast {
            castCollectionVC?.casts = casts
            tableView.beginUpdates()
            let indexSet = IndexSet(integer: TableSections.cast.rawValue)
            tableView.insertSections(indexSet, with: .bottom)
            tableView.endUpdates()
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let hasCast = movie?.credits?.cast != nil
        return hasCast ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableSections(rawValue: section)?.rows ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = tableView.backgroundColor
    }
    
}
