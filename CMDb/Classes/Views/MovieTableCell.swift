//
//  MovieTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import TMDb

class MovieTableCell: UITableViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        overviewLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        posterImageView.setImage(with: movie.posterURL(width: .w92))
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseYear
        overviewLabel.text = movie.overview
    }
    
}
