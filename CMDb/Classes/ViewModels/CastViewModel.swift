//
//  CastViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/19/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

struct CastViewModel: ProfileDownloadable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    init?(with cast: Cast) {
        // Accepting only the ones that have a profile image
        guard let imagePath = cast.profilePath else { return nil }
        
        id = cast.id
        name = cast.name
        character = cast.character
        profilePath = imagePath
    }
}
