//
//  Cast.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Cast: Decodable {
    let id: Int
    let order: Int
    let name: String
    let character: String
    let gender: Gender
    let profilePath: String
    let creditID: String
    let castID: Int?

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
