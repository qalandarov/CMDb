//
//  ImageDownloadable.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public protocol ImageDownloadable {
    var posterPath: String? { get }
    var backdropPath: String? { get }
}

extension ImageDownloadable {
    public func posterURL(width: ImageWidth = .w185) -> URL? {
        return width.url(for: posterPath)
    }
    
    public func backdropURL(width: ImageWidth = .w500) -> URL? {
        return width.url(for: backdropPath)
    }
}
