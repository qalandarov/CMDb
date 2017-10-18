//
//  MovieDetailsTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/9/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieDetailsTVC: UITableViewController, SegueHandlerType {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var movie: Movie?
    private var castCollectionVC: ProfilesCollectionVC?
    private var originalOffsetY: CGFloat = 0
    private var originalImageFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        fetchDetailsIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalOffsetY = tableView.contentOffset.y
        originalImageFrame = imageView.frame
    }
    
    private func prepareUI() {
        guard let movie = movie else { return }
        
        let url = movie.backdropURL() ?? movie.posterURL()
        imageView.setImage(with: url)
        
        posterImageView.setPosterImage(with: movie, width: .w92)
        
        titleLabel.text = movie.title + " (\(movie.releaseYear))" // title + (YYYY)
        genreLabel.text = movie.genres?.map({ $0.name }).joined(separator: ", ")
        
        textView.textContainerInset = .zero
        textView.text = movie.overview
        
        if let casts = movie.credits?.cast, !casts.isEmpty {
            castCollectionVC?.casts = casts
            insertCastSection()
        }
    }
    
    private func insertCastSection() {
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integer: 2), with: .bottom)
        tableView.endUpdates()
    }
    
    private func fetchDetailsIfNeeded() {
        guard let movie = movie, movie.credits?.cast == nil else { return }

        let op = MovieDetailsDownloadOperation(movieID: movie.id)
        op.completionBlock = {
            OperationQueue.main.addOperation {
                self.movie = op.movie
                self.prepareUI()
            }
        }
        
        op.start()
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = tableView.backgroundColor
    }
    
}

extension MovieDetailsTVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = originalOffsetY - scrollView.contentOffset.y
        
        var frame = originalImageFrame
        if delta > 0 {
            frame.origin.y = -delta
            frame.size.height += delta
        }
        imageView.frame = frame
    }
}
