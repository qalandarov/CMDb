//
//  ProfilesCollectionVC.swift
//  CMDb
//
//  Created by Islam Qalandarov on 9/9/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import UIKit

class ProfilesCollectionVC: UICollectionViewController {
    
    var casts: [CastViewModel]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var castsCount: Int {
        return casts?.count ?? 0
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        
        if let cast = casts?[indexPath.item] {
            cell.profileImageView.setImage(with: cast.profileURL())
            cell.nameLabel.text = cast.name
            cell.characterLabel.text = cast.character
        }
        
        return cell
    }
    
}
