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
    
    func insertOrUpdate(_ search: Search<Movie>, for query: String) {
        let workerContext = tempWorkerContext()
        SearchMO.insertOrUpdate(search, for: query, in: workerContext)
        workerContext.saveIfNeeded()
    }
    
    func latestSearchQueries() -> [String]? {
        let request = SearchMO.fetchRequest
        request.fetchLimit = 10
        request.propertiesToFetch = ["query"]
        request.resultType = .dictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        let dict = SearchMO.fetchDict(request, from: mainContext)
        return dict?.flatMap { $0.values }
    }
    
}
