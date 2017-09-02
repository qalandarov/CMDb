//
//  ErrorResponse.swift
//  TMDb
//
//  Created by Islam Qalandarov on 9/2/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}
