//
//  SegueValidatable.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/6/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

/// Protocol that helps to validate if a segue is valid and that a view controller has handled it
protocol SegueValidatable: RawRepresentable {
    /// Each segue identifer requires the destination type to be specified
    var expectedType: UIViewController.Type { get }
    /// Validates destination view controller against the expectedType
    func isValid(_ segue: UIStoryboardSegue) -> Bool
    /// Returns valid destination view controller if the type is as of expectedType
    func destination<T>(from segue: UIStoryboardSegue, as type: T.Type) -> T?
}

/// Protocol extension to help validate a segue
extension SegueValidatable {
    /// Validates destination view controller against the expectedType
    func isValid(_ segue: UIStoryboardSegue) -> Bool {
        return type(of: segue.destination) == expectedType
    }
    
    /// Returns valid destination view controller if the type is as of expectedType
    func destination<T>(from segue: UIStoryboardSegue, as type: T.Type) -> T? {
        guard type == expectedType, let casted = segue.destination as? T else {
            assertionFailure("""
                Segue destination Type Mismatch:
                - requesting type: \(type)
                - expected type: \(expectedType)
                """)
            return nil
        }
        return casted
    }
}
