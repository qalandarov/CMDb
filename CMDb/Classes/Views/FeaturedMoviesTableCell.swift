//
//  FeaturedMoviesTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel
import TMDb

class FeaturedMoviesTableCell: UITableViewCell {

    @IBOutlet weak var bgCarousel: iCarousel!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var placeholderView: UIView!
    
    var moviePresentor: MoviePresentable?
    
    private var vms: [MovieViewModel] = [] {
        didSet {
            carousel.reloadData()
            bgCarousel.reloadData()
            carousel.currentItemIndex = vms.count / 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgCarousel.bounces = false
        bgCarousel.delegate = self
        bgCarousel.dataSource = self
        
        carousel.type = .coverFlow
        carousel.delegate = self
        carousel.dataSource = self
        
        placeholderView.backgroundColor = .clear
    }
    
    func configure(with vms: [MovieViewModel], presentor: MoviePresentable) {
        self.vms = vms
        moviePresentor = presentor
    }
    
}

extension FeaturedMoviesTableCell: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return vms.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let bg = carousel == bgCarousel
        let frame = bg ? carousel.frame : placeholderView.frame
        let posterView = view as? UIImageView ?? UIImageView(frame: frame)
        posterView.setPosterImage(with: vms[index])
        return posterView
    }
}

extension FeaturedMoviesTableCell: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        guard index == carousel.currentItemIndex else { return }
        moviePresentor?.didSelectMovie(vms[index])
    }
}
