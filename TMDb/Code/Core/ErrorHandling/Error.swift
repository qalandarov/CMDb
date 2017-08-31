//
//  Error.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

protocol ErrorType: Swift.Error {
    var string: String { get }
}

enum Error: ErrorType {
    case general(errorMsg: String)
    case incorrectResponse
    
    init(_ errorMsg: String) {
        self = Error.general(errorMsg: errorMsg)
    }
    
    var string: String {
        switch self {
        case .general(let errorMsg):
            return errorMsg
        case .incorrectResponse:
            return "Incorrect data"
        }
    }
}
