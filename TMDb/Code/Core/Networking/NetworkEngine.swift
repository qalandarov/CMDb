//
//  NetworkEngine.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public typealias ResultCompletionGeneric<T> = (Result<T>) -> Void
public typealias ResultCompletionMovie = (Result<Movie>) -> Void
public typealias ResultCompletionMovies = (Result<[Movie]>) -> Void
public typealias ResultCompletionSearchMovie = (Result<Search<Movie>>) -> Void
public typealias ResultCompletionGenericSearch<T: Decodable & Equatable> = (Result<Search<T>>) -> Void

public class NetworkEngine {
    
    var currentTask: URLSessionDataTask?
    
    public init() {}
    
    deinit {
        currentTask?.cancel()
    }

    public func searchMovie(query: String, page: Int = 1, completion: @escaping ResultCompletionGenericSearch<Movie>) {
        guard !query.isEmpty else {
            completion(.failure(.general(errorMsg: "Query must be provided")))
            return
        }
        fetch(resource: .searchMovie(query: query, page: page)) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    public func movies(type: MovieSectionType, completion: @escaping ResultCompletionSearchMovie) {
        fetch(resource: .movies(type: type)) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    public func movieDetails(id: Int, completion: @escaping ResultCompletionMovie) {
        let detailTypes: [DetailType] = [.credits, .images, .videos]
        fetch(resource: .movieDetails(id: id, detailTypes: detailTypes)) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    func fetch<T: Decodable>(resource: Router, completion: @escaping ResultCompletionGeneric<T>) {
        guard let request = resource.request else {
            completion(.failure(.incorrectRequest))
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.general(errorMsg: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.incorrectResponse))
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                if let contentError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    completion(.failure(.general(errorMsg: contentError.message)))
                } else {
                    completion(.failure(.incorrectResponse))
                }
                return
            }
            
            completion(.success(result))
        }
        
        currentTask?.resume()
    }
    
}
