//
//  Trailer.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/8/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Trailer: Decodable {
    public let id: Int?
    let results: [Video]
    
    public var videos: [Video] {
        return results.filter({ $0.isYoutube })
    }
}

public struct Video: Decodable {
    public let id: String
    public let name: String
    let key: String
    let site: String
    
    var isYoutube: Bool {
        return site.lowercased() == "youtube"
    }
    
    public var url: URL? {
        guard !key.isEmpty && isYoutube else { return nil }
        return URL(string: "https://youtu.be/\(key)")
    }
}
