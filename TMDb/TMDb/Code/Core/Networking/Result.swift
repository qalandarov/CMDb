//
//  Result.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
    // f is a function that when proccessed returns a specific value (U)
    public func map<U>(_ f: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(f(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // f is a function that when proccessed returns another Result<> enum
    public func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            return f(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
