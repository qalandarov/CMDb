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
        return processFetch(request, from: context)
    }
    
    // A fetch processor with a request that returns Dictionary result
    static func fetchDict(_ request: NSFetchRequest<Self>, from context: NSManagedObjectContext) -> [[String: String]]? {
        guard
            request.resultType == .dictionaryResultType,
            let dictRequest = request as? NSFetchRequest<NSFetchRequestResult>
            else {
                assertionFailure("Incorrect request passed")
                return nil
        }
        
        return processFetch(dictRequest, from: context)
    }
    
    /// A helper variable to prevent ambiguous reference while using native `fetchRequest()`
    static var fetchRequest: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: String(describing: Self.self))
    }
}

private extension EasyFetchable {
    /// This function is created to cater for both ManagedObject and Dictionary return types.
    /// In the case of ManagedObject -> T = U = ManagedObject
    /// In the case of Dictionary    -> T = NSFetchRequestResult, U = [String: String]
    private static func processFetch<T, U>(_ request: NSFetchRequest<T>, from context: NSManagedObjectContext) -> [U]? {
        do {
            return try context.fetch(request) as? [U]
        } catch let error as NSError {
            assertionFailure("Error fetching \(Self.self): \(error.userInfo)")
        }
        
        return nil
    }
}
