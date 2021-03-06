//
//  DBManager.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/2/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import Foundation

protocol DBManagable {
    // DB Actions
    func save()
    
    // Search Actions
    func insertOrUpdate(_ search: Search<Movie>, for query: String) -> SearchMO
    /// Returns the last 10 successful search queries
    func latestSearchQueries() -> [String]
    func search(for query: String) -> SearchMO?
}

public class DBManager {
    
    public static let shared = DBManager()
    
    private let db: DBManagable
    
    init (with dbManagable: DBManagable = CoreDataStack()) {
        db = dbManagable
    }
    
}

// MARK: - Public API

// DB Actions
extension DBManager {
    public func save() {
        db.save()
    }
}

// Search Actions
extension DBManager {
    public func insertOrUpdate(_ search: Search<Movie>, for query: String) -> SearchMO {
        return db.insertOrUpdate(search, for: query)
    }
    
    public func latestSearchQueries() -> [String] {
        return db.latestSearchQueries()
    }
    
    public func search(for query: String) -> SearchMO? {
        return db.search(for: query)
    }
}
