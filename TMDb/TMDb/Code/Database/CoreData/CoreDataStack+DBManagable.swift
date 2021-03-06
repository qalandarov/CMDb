//
//  CoreData+DBManagable.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/6/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import CoreData

extension CoreDataStack: DBManagable {} // Implementation is broken down below

// MARK: - DB Actions

extension CoreDataStack {
    // mainContext -> bgContext -> Persistent Container (Disk IO)
    func save() {
        // Saves the changes to bgContext
        mainContext.saveIfNeeded()
        // Saves the changes to Persistent Container
        bgContext.saveIfNeeded()
    }
}

// MARK: - Search Actions

extension CoreDataStack {
    
    func insertOrUpdate(_ search: Search<Movie>, for query: String) -> SearchMO {
        let workerContext = tempWorkerContext()
        SearchMO.insertOrUpdate(search, for: query, in: workerContext)
        workerContext.saveIfNeeded()
        
        // When worker saves the mainContext should definitely have this search object
        // It's not an ideal way of handling, but doing it for the demo purposes
        return self.search(for: query)!
    }
    
    func latestSearchQueries() -> [String] {
        let request = SearchMO.fetchRequest
        request.fetchLimit = 10
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        let searches = SearchMO.fetch(request, from: mainContext)
        return searches?.flatMap({ $0.query }) ?? []
    }
    
    func search(for query: String) -> SearchMO? {
        return SearchMO.existing(with: query, in: mainContext)
    }
    
}
