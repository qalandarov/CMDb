//
//  MovieSectionTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit
import iCarousel

private let sectionTitleLeadingGap: CGFloat = 15

class MovieSectionTableCell: UITableViewCell {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var bgCarousel: iCarousel!
    @IBOutlet weak var carousel: iCarousel!
    
    var moviePresentor: MoviePresentable?
    
    var vms: [MovieViewModel] = [] {
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
    
    func configure(with vms: [MovieViewModel], title: String, presentor: MoviePresentable) {
        self.vms = vms
        moviePresentor = presentor
        titleButton.setTitle(title, for: .normal)
    }
    
}

// MARK: - Carousel Data Source

extension MovieSectionTableCell: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return vms.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var frame = carousel.frame
        frame.size.width -= sectionTitleLeadingGap * 2 // gap
        
        let backdropView = view as? UIImageView ?? UIImageView(frame: frame)
        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true
        backdropView.setImage(with: vms[index].backdropURL())
        return backdropView
    }
}

// MARK: - Carousel Delegate

extension MovieSectionTableCell: iCarouselDelegate {
    func carouselDidScroll(_ carousel: iCarousel) {
        bgCarousel.scrollOffset = carousel.scrollOffset
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        guard index == carousel.currentItemIndex else { return }
        moviePresentor?.didSelectMovie(vms[index])
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.025
        }
        return value
    }
}
