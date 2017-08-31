//
//  Error.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public protocol ErrorType: Swift.Error {
    var string: String { get }
}

public enum Error: ErrorType {
    case general(errorMsg: String)
    case incorrectResponse
    
    init(_ errorMsg: String) {
        self = Error.general(errorMsg: errorMsg)
    }
    
    public var string: String {
        switch self {
        case .general(let errorMsg):
            return errorMsg
        case .incorrectResponse:
            return "Incorrect data"
        }
    }
}
