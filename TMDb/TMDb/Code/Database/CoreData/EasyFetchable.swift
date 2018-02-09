//
//  EasyFetchable.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/9/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import CoreData

/// Convenient protocol to ease the process of fetching
protocol EasyFetchable {}

// Confirming NSManagedObject to EasyFetchable so all of its subclasses inherit this
extension NSManagedObject: EasyFetchable {}

extension EasyFetchable where Self: NSManagedObject {
    /// A fetch processor with an optional predicate and sort descriptions (if they're nil == returns ALL objects)
    static func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      from context: NSManagedObjectContext) -> [Self]?
    {
        let request = fetchRequest
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return fetch(request, from: context)
    }
    
    // A fetch processor with a request
    static func fetch(_ request: NSFetchRequest<Self>, from context: NSManagedObjectContext) -> [Self]? {
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            assertionFailure("Error fetching \(Self.self): \(error.userInfo)")
        }
        
        return nil
    }
    
    /// A helper variable to prevent ambiguous reference while using native `fetchRequest()`
    static var fetchRequest: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: String(describing: Self.self))
    }
}
