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
    
    public var height: Int {
        switch self {
        case .w92:  return 135
        case .w185: return 278
        case .w500: return 735
        case .w780: return 1147
        }
    }
    
    public var size: CGSize {
        return CGSize(width: width, height: height)
    }
}
