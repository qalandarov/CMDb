//
//  Crew.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Crew: Decodable, ProfileDownloadable {
    public let id: Int
    public let name: String
    public let department: String
    public let gender: Gender
    public let job: String
    public let creditID: String
    public let profilePath: String?
    
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
