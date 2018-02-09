//
//  CoreDataStack.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/2/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() {
        guard hasChanges else { return }
        
        do {
            try save()
        } catch {
            assertionFailure("Couldn't save the context")
        }
    }
}

class CoreDataStack {
    
    // Built from the mainContext for temporary works
    func tempWorkerContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    // Built from the bgContext to be used in the UI layer
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = bgContext
        return context
    }()
    
    // The only context that writes to the PSC (so if the writing takes too long the UI doesn't lag)
    lazy var bgContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        // Getting the bundle as it's a Framework
        let bundle = Bundle(for: type(of: self))
        let dataModelName = "TMDb"
        
        guard
            let modelURL = bundle.url(forResource: dataModelName, withExtension:"momd"),
            let mom = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("Unable to initialize the model")
        }
        
        let container = NSPersistentContainer(name: dataModelName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
}
