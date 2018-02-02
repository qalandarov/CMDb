//
//  Search.swift
//  TMDb
//
//  Created by Islam Qalandarov on 8/31/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

public struct Search<T: Decodable & Equatable>: Decodable {
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    public let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

public extension Search {
    
    var hasNextPage: Bool {
        return page < totalPages
    }
    
    var isValid: Bool {
        return totalResults > 0
    }
    
    /*
     *  Assuming that the search pages will be always called in ascending order
     */
    func combined(with search: Search) -> Search {
        guard search.page > page else { return self }
        
        var combinedResults = results
        
        // In case if the new items are added to the search it is possible that
        // some of the items in the current page will be moved to the next page.
        // So, we need to filter the ones that we don't already have to prevent duplicates
        combinedResults += search.results.filter { !results.contains($0) }
        
        return Search(page: search.page,
                      totalPages: totalPages,
                      totalResults: totalResults,
                      results: combinedResults)
    }
    
}
