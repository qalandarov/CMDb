//
//  ProfileDownloadable.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public protocol ProfileDownloadable {
    var profilePath: String? { get }
}

public extension ProfileDownloadable {
    func profileURL(width: ImageWidth = .w92) -> URL? {
        return width.url(for: profilePath)
    }
}
