//
//  NetworkEngine.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public typealias VoidCompletion = () -> Void
public typealias ResultCompletionGeneric<T> = (Result<T>) -> Void
public typealias ResultCompletionData = (Result<Data>) -> Void
public typealias ResultCompletionMovie = (Result<Movie>) -> Void
public typealias ResultCompletionMovies = (Result<[Movie]>) -> Void
public typealias ResultCompletionSearchMovie = (Result<Search<Movie>>) -> Void
public typealias ResultCompletionGenericSearch<T: Decodable & Equatable> = (Result<Search<T>>) -> Void

public class NetworkEngine {
    public init() {}
    private var currentTask: URLSessionDataTask?
    deinit { cancel() }
    
    public func cancel() {
        currentTask?.cancel()
    }
}
    
// MARK: - Public API

public extension NetworkEngine {
    
    func searchMovie(query: String, page: Int = 1, completion: @escaping ResultCompletionGenericSearch<Movie>) {
        guard !query.isEmpty else {
            completion(.failure(.general(errorMsg: "Query must be provided")))
            return
        }
        fetch(.searchMovie(query: query, page: page), completion: completion)
    }
    
    func movies(type: MovieSectionType, completion: @escaping ResultCompletionSearchMovie) {
        fetch(.movies(type: type), completion: completion)
    }
    
    func movieDetails(id: Int, completion: @escaping ResultCompletionMovie) {
        let detailTypes: [DetailType] = [.credits, .images, .videos]
        fetch(.movieDetails(id: id, detailTypes: detailTypes), completion: completion)
    }
    
}

// MARK: - Private Implementation

private extension NetworkEngine {
    
    func fetch<T: Decodable>(_ resource: Router, completion: @escaping ResultCompletionGeneric<T>) {
        currentTask = fetch(resource) { [weak self] result in
            guard let strongSelf = self else { return }
            completion(result.flatMap(strongSelf.decode))
        }
        currentTask?.resume()
    }
    
    func fetch(_ router: Router, completion: @escaping ResultCompletionData) -> URLSessionDataTask? {
        guard let request = router.request else {
            assertionFailure("Incorrect request")
            completion(.failure(.incorrectRequest))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else {
                let errorObject = Error(error?.localizedDescription)
                completion(.failure(errorObject))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
        return task
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T> {
        if let decoded = data.decoded(as: T.self) {
            return .success(decoded)
        }
        
        if let contentError = data.decodedError {
            debugPrint("Error while decoding: \(contentError)")
            return .failure(.general(errorMsg: contentError.message))
        }
        
        return .failure(.incorrectResponse)
    }
    
}

private extension Data {
    var decodedError: ErrorResponse? {
        return decoded()
    }
    
    func decoded<T: Decodable>(as type: T.Type) -> T? {
        return decoded()
    }
    
    private func decoded<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try! decoder.decode(T.self, from: self)
    }
}
