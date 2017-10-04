//
//  Storyboard.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/4/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

enum Storyboard {
    case search
    
    func viewController<T: UIViewController>() -> T? {
        let vcName = String(describing: T.self)
        let vc = storyboard.instantiateViewController(withIdentifier: vcName)
        assert(type(of: vc) == T.self, "Couldn't find the requested view controller")
        return vc as? T
    }
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    private var name: String {
        switch self {
        case .search: return "Search"
        }
    }
}
