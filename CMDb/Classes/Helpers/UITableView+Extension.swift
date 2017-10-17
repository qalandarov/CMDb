//
//  UITableView+Extension.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let reuseID = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! T
    }
}
