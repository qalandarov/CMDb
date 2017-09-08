//
//  DetailType.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public enum DetailType: String {
    case credits
    case images
    case videos
    case reviews
    case similar
    case keywords
}

extension Sequence where Iterator.Element == DetailType {
    var csv: String {
        return map({ $0.rawValue }).joined(separator: ",")
    }
}
