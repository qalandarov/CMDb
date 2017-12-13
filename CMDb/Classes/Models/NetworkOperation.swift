//
//  NetworkOperation.swift
//  CMDb
//
//  Created by Islam Qalandarov on 12/11/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

class NetworkOperation<T>: AsyncOperation {
    lazy var network = NetworkEngine()
    var result: Result<T>?
    
    var error: TMDb.Error? { return result?.error }
    
    override func cancel() {
        network.cancel()
        super.cancel()
    }
    
    func handleCompletion(_ result: Result<T>) {
        guard !isCancelled else { return }
        self.result = result
        finish()
    }
}
