//
//  MovieSectionTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel

class MovieSectionTableCell: UITableViewCell {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var bgCarousel: iCarousel!
    @IBOutlet weak var carousel: iCarousel!
    
    private var backdropURLs: [URL]? {
        didSet {
            carousel.reloadData()
            bgCarousel.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgCarousel.bounces = false
        bgCarousel.delegate = self
        bgCarousel.dataSource = self
        
        carousel.delegate = self
        carousel.dataSource = self
        carousel.isPagingEnabled = true
        carousel.backgroundColor = .clear
        carousel.bounceDistance = 0.5
    }
    
    func configure(with section: MovieSection?) {
        backdropURLs = section?.urls
        titleButton.setTitle(section?.title, for: .normal)
    }
    
}

extension MovieSectionTableCell: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return backdropURLs?.count ?? 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let backdropView = view as? UIImageView ?? UIImageView(frame: carousel.frame)
        backdropView.contentMode = .scaleAspectFill
        backdropView.setImage(with: backdropURLs![index])
        return backdropView
    }
}

extension MovieSectionTableCell: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
}
