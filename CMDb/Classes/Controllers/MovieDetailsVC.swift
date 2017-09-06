//
//  MovieDetailsVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/6/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImage(with: imageURL)
    }
    
}

