//
//  PreviousSearchCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 1/1/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import UIKit

class PreviousSearchCell: UITableViewCell {
    
    var searchText: String {
        get {
            return textLabel?.text ?? ""
        }
        set {
            textLabel?.text = newValue
        }
    }
    
}
