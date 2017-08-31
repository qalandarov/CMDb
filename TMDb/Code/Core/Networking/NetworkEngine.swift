//
//  NetworkEngine.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

typealias ResultCompletionGeneric<T> = (Result<T>) -> Void

class NetworkEngine {
    
    var currentTask: URLSessionDataTask?
    
    deinit {
        currentTask?.cancel()
    }

    func fetch<T: Decodable>(completion: @escaping ResultCompletionGeneric<T>) {
        let requestURL = URL(string: C.BaseURLString)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        currentTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.general(errorMsg: error.localizedDescription)))
                return
            }
            
            guard let data = data, let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.incorrectResponse))
                return
            }
            
            completion(.success(result))
        }
        
        currentTask?.resume()
    }
    
}
