//
//  ImageWidth.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/2/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public enum ImageWidth: String {
    case w92, w185, w500, w780
    
    public var width: Int {
        switch self {
        case .w92:  return 92
        case .w185: return 185
        case .w500: return 500
        case .w780: return 780
        }
    }
    
    public var posterHeight: Int {
        switch self {
        case .w92:  return 135
        case .w185: return 278
        case .w500: return 735
        case .w780: return 1147
        }
    }
    
    public var backdropHeight: Int {
        switch self {
        case .w92:  return 52
        case .w185: return 104
        case .w500: return 281
        case .w780: return 439
        }
    }
    
    public var posterSize: CGSize {
        return CGSize(width: width, height: posterHeight)
    }
    
    public var backdropSize: CGSize {
        return CGSize(width: width, height: backdropHeight)
    }
    
    func url(for path: String?) -> URL? {
        guard let path = path else { return nil }
        var url = URL(string: C.BaseImageURLString)
        url?.appendPathComponent(rawValue)
        url?.appendPathComponent(path)
        return url
    }
}
