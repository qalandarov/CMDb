//
//  Artwork.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Artwork: Decodable {
    public let id: Int?
    public let backdrops: [Image]
    public let posters: [Image]
}

public struct Image: Decodable {
    let filePath: String
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

