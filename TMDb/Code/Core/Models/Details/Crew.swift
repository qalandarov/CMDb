//
//  Crew.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Crew: Decodable {
    let id: Int
    let name: String
    let department: String
    let gender: Gender
    let job: String
    let profilePath: String
    let creditID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case department
        case gender
        case job
        case profilePath = "profile_path"
        case creditID = "credit_id"
    }
}
