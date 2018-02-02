//
//  Cast.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Cast: Decodable, ProfileDownloadable {
    public let id: Int
    public let order: Int
    public let name: String
    public let character: String
    public let gender: Gender
    public let creditID: String
    public let profilePath: String?
    public let castID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case order
        case name
        case character
        case gender
        case profilePath    = "profile_path"
        case creditID       = "credit_id"
        case castID         = "cast_id"
    }
}
