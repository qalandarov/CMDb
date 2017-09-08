//
//  Credits.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
