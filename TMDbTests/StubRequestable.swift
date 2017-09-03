//
//  StubRequestable.swift
//  TMDbTests
//
//  Created by Islam Qalandarov on 9/3/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation

protocol StubRequestable: class {
    func requestJSONStub(with name: String) -> Data?
}

extension StubRequestable {
    func requestJSONStub(with name: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            return try Data(contentsOf: url)
        } catch {
            print(error)
        }
        
        return nil
    }
}
