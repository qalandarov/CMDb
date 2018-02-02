//
//  HomeViewModel.swift
//  CMDb
//
//  Created by Islam Qalandarov on 10/17/17.
//  Copyright © 2017 Qalandarov. All rights reserved.
//

import Foundation
import TMDb

private enum MovieSection: Int {
    case upcoming
    case popular
    case topRated
    
    static var count = 3
    
    var title: String {
        switch self {
        case .upcoming:     return ""
        case .popular:      return "Popular >"
        case .topRated:     return "Top Rated >"
        }
    }
}

class HomeViewModel {
    
    fileprivate lazy var movieSections: [MovieSection : [MovieViewModel]] = [:]
    
    var numberOfSections: Int {
        return MovieSection.count
    }
    
    func movieViewModels(at indexPath: IndexPath) -> [MovieViewModel] {
        guard let section = MovieSection(rawValue: indexPath.row) else {
            return []
        }
        return movieSections[section] ?? []
    }
    
    func title(at indexPath: IndexPath) -> String {
        return MovieSection(rawValue: indexPath.row)?.title ?? ""
    }
    
}

// Networking
extension HomeViewModel {
    func fetchAllSections(completion: @escaping (() -> ())) {
        let upcomingOp = MovieSectionDownloadOperation(section: .upcoming)
        let popularOp  = MovieSectionDownloadOperation(section: .popular)
        let topRatedOp = MovieSectionDownloadOperation(section: .toprated)
        
        let blockOp = BlockOperation {
            guard
                let upcoming = upcomingOp.movies,
                let popular  = popularOp.movies,
                let topRated = topRatedOp.movies
                else {
                    debugPrint("There's an error")
                    completion()
                    return
            }
            
            self.movieSections[.upcoming] = upcoming
            self.movieSections[.popular]  = popular
            self.movieSections[.topRated] = topRated
            completion()
        }
        
        blockOp.addDependency(upcomingOp)
        blockOp.addDependency(popularOp)
        blockOp.addDependency(topRatedOp)
        
        OperationQueue().addOperations([upcomingOp, popularOp, topRatedOp], waitUntilFinished: false)
        OperationQueue.main.addOperation(blockOp)
    }
}
