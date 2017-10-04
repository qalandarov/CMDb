//
//  MovieSectionTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel
import TMDb

private let sectionTitleLeadingGap: CGFloat = 15

class MovieSectionTableCell: UITableViewCell {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var bgCarousel: iCarousel!
    @IBOutlet weak var carousel: iCarousel!
    
    var moviePresentor: MoviePresentable?
    
    var movies: [Movie] = [] {
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
    
    func configure(with movies: [Movie], title: String, presentor: MoviePresentable) {
        self.movies = movies
        moviePresentor = presentor
        titleButton.setTitle(title, for: .normal)
    }
    
}

extension MovieSectionTableCell: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return movies.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var frame = carousel.frame
        frame.size.width -= sectionTitleLeadingGap * 2 // gap
        
        let backdropView = view as? UIImageView ?? UIImageView(frame: frame)
        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true
        backdropView.setImage(with: movies[index].backdropURL())
        return backdropView
    }
}

extension MovieSectionTableCell: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        guard index == carousel.currentItemIndex else { return }
        moviePresentor?.didSelectMovie(movies[index])
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.025
        }
        return value
    }
}
