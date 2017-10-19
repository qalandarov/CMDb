//
//  UIImageView+Extension.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb
import Kingfisher

extension UIImageView {
    func setPosterImage(with downloadable: ImageDownloadable, width: ImageWidth = .w185) {
        setImage(with: downloadable.posterURL(width: width))
    }
    
    func setBackdropImage(with downloadable: ImageDownloadable, width: ImageWidth = .w500) {
        setImage(with: downloadable.backdropURL(width: width))
    }
    
    func setImage(with url: URL?) {
        kf.cancelDownloadTask()
        kf.indicatorType = .activity
        (kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        kf.setImage(with: url)
    }
}
