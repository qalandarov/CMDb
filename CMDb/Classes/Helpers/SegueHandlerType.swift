//
//  SegueHandlerType.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/6/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//
//  Credit: NatashaTheRobot for the initial idea: https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

import UIKit

/// Protocol that enforces a conforming type to have SegueIdentifer (enum) which would help to handle segues
protocol SegueHandlerType {
    associatedtype SegueIdentifier: SegueValidatable
}

/// Protocol extension to handle segue validation and UIStoryboardSegue -> SegueIdentifier conversion
extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(_ segueIdentifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier? {
        guard
            let identifier = segue.identifier,
            let segueID = SegueIdentifier(rawValue: identifier),
            segueID.isValid(segue)
            else {
                assertionFailure("""
                    Invalid segue:
                    - identifier: \(segue.identifier ?? "")
                    - destination type: \(type(of: segue.destination))
                    """)
                return nil
        }
        
        return segueID
    }
}
