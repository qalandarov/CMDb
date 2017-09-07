//
//  MovieDetailsVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/6/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        guard let movie = movie else { return }
        
        title = movie.title + " (\(movie.releaseYear))" // title + (YYYY)
        
        bgImageView.setPosterImage(with: movie)
        imageView.setBackdropImage(with: movie)
    }
    
}

