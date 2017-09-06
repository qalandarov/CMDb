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
    var expectedType: UIViewController.Type { get }
    func isValid(_ segue: UIStoryboardSegue) -> Bool
    func destination<T: UIViewController>(from segue: UIStoryboardSegue) -> T?
}

/// Protocol extension to help validate a segue
extension SegueValidatable {
    func isValid(_ segue: UIStoryboardSegue) -> Bool {
        return type(of: segue.destination) == expectedType
    }
    
    func destination<T: UIViewController>(from segue: UIStoryboardSegue) -> T? {
        let requestedType = T.self
        guard requestedType == expectedType, let casted = segue.destination as? T else {
            assertionFailure("""
                Segue destination Type Mismatch:
                - requesting type: \(requestedType)
                - expected type: \(expectedType)
                """)
            return nil
        }
        return casted
    }
}
