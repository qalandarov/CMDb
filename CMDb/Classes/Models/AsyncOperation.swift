//
//  AsyncOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//
//  Credits: https://stackoverflow.com/questions/36675986

import Foundation

class AsyncOperation: Operation {
    private enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    private var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override func start() {
        guard state == .ready else { return }
        state = .executing
    }
    
    override func cancel() {
        // Need to call super.cancel() FIRST to update cancelled state
        super.cancel()
        // Then mark it as finished
        state = .finished
    }
    
    func finish() {
        state = .finished
    }
}

extension AsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}
