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
    case incorrectRequest
    case unexpected
    
    init(_ errorMsg: String?) {
        if let msg = errorMsg {
            self = .general(errorMsg: msg)
        } else {
            self = .unexpected
        }
    }
    
    public var string: String {
        switch self {
        case .general(let errorMsg):
            return errorMsg
        case .incorrectResponse:
            return "Unexpected response received from the server"
        case .incorrectRequest:
            return "Something is wrong with the configurations"
        case .unexpected:
            return "Unexpected error"
        }
    }
}
