//
//  SearchMO+Extension.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/8/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import CoreData

extension SearchMO {
    
    @discardableResult
    static func insertOrUpdate(_ search: Search<Movie>, for query: String, in context: NSManagedObjectContext) -> SearchMO {
        if let searchObject = SearchMO.existing(with: query, in: context) {
            searchObject.modify(with: search, in: context)
            return searchObject
        }
        
        return SearchMO(with: search, for: query, in: context)
    }
    
    static func existing(with query: String, in context: NSManagedObjectContext) -> SearchMO? {
        let request = SearchMO.fetchRequest
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "query == [c] %@", query)
        let searches = SearchMO.fetch(request, from: context)
        return searches?.first
    }
    
    private convenience init(with search: Search<Movie>, for query: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.query = query
        self.modify(with: search, in: context)
    }
    
    private func modify(with search: Search<Movie>, in context: NSManagedObjectContext) {
        updatedAt = Date()
        
        page = Int64(search.page)
        totalPages = Int64(search.totalPages)
        totalResults = Int64(search.totalResults)
        
        for movie in search.results {
            let movieObject = MovieMO.insertOrUpdate(movie, in: context)
            movieObject.search = self
        }
    }
    
}
