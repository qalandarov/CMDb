//
//  UIViewController+Extension.swift
//  CMDb
//
//  Created by Islam Qalandarov on 1/1/18.
//  Copyright © 2018 Qalandarov. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
