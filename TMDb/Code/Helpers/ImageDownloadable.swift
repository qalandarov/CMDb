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
    public func posterURL(width: ImageWidth) -> URL? {
        return url(for: posterPath, width: width)
    }
    
    public func backdropURL(width: ImageWidth) -> URL? {
        return url(for: backdropPath, width: width)
    }
    
    private func url(for path: String?, width: ImageWidth) -> URL? {
        guard let path = path else { return nil }
        var url = URL(string: C.BaseImageURLString)
        url?.appendPathComponent(width.rawValue)
        url?.appendPathComponent(path)
        return url
    }
}
