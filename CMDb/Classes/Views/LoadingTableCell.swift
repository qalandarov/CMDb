//
//  LoadingTableCell.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/9/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

class LoadingTableCell: UITableViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.startAnimating()
    }
    
}
