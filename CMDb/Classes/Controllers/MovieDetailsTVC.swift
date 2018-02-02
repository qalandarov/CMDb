//
//  MovieDetailsTVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/9/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

class MovieDetailsTVC: UITableViewController, SegueHandlerType {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var vm: MovieViewModel?
    private var castCollectionVC: ProfilesCollectionVC?
    private var originalOffsetY: CGFloat = 0
    private var originalImageFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
        vm?.fetchDetailsIfNeeded { [weak self] in
            self?.insertCastsIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalOffsetY = tableView.contentOffset.y
        originalImageFrame = imageView.frame
    }
    
    private func prepareUI() {
        guard let vm = vm else { return }
        
        let url = vm.backdropURL() ?? vm.posterURL()
        imageView.setImage(with: url)
        
        posterImageView.setPosterImage(with: vm, width: .w92)
        
        titleLabel.text = vm.titleAndYear
        genreLabel.text = vm.genres
        
        textView.textContainerInset = .zero
        textView.text = vm.overview
        
        insertCastsIfNeeded()
    }
    
    private func insertCastsIfNeeded() {
        guard vm?.hasCast == true else { return }
        
        castCollectionVC?.casts = vm?.casts
        
        tableView.beginUpdates()
        let indexSet = IndexSet(integer: 2)
        tableView.insertSections(indexSet, with: .bottom)
        tableView.endUpdates()
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
        return (vm?.hasCast == true) ? 3 : 2
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
