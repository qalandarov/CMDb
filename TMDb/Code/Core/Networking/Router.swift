//
//  Router.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/2/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum ContentType: String {
    static let HeaderField = "Content-Type"
    case json = "application/json; charset=utf-8"
}

enum Router {
    static var baseURLString = "https://api.themoviedb.org/3"
    private static var apiKey = "2696829a81b1b5827d515ff121700838"
    
    case searchMovie(query: String, page: Int)
    
    private var method: HTTPMethod {
        return .get
    }
    
    private var contentType: ContentType {
        return .json
    }
    
    private var path: String {
        switch self {
        case .searchMovie:
            return "/search/movie"
        }
    }
    
    private var parameters: [String : Any] {
        var params: [String : Any] = ["api_key" : Router.apiKey]
        
        switch self {
        case .searchMovie(let query, let page):
            params += ["query" : query, "page" : page]
        }
        
        return params
    }
    
    var request: URLRequest? {
        guard let url = URL(string: Router.baseURLString) else { return nil }
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.encode(parameters: parameters)
        request.contentType = contentType.rawValue
        return request
    }
}
