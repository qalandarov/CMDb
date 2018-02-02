//
//  DBManager.swift
//  TMDb
//
//  Created by Islam Qalandarov on 2/2/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import Foundation

class DBManager {
    
    public static let shared = DBManager()
    
    private let coreDataStack: CoreDataStack
    
    private init () {
        coreDataStack = CoreDataStack()
    }
    
    // MARK: Public functions
    
    public func save() {
        coreDataStack.saveContext()
    }
    
}
