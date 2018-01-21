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
    case topRated
    case popular
    
    var title: String {
        switch self {
        case .upcoming:     return ""
        case .topRated:     return "Top Rated >"
        case .popular:      return "Popular >"
        }
    }
}

class HomeViewModel {
    
    fileprivate lazy var movieSections: [MovieSection : [MovieViewModel]] = [:]
    
    var numberOfSections: Int {
        return [MovieSection.upcoming, .topRated, .popular].count
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
        let topRatedOp = MovieSectionDownloadOperation(section: .toprated)
        let popularOp  = MovieSectionDownloadOperation(section: .popular)
        
        let blockOp = BlockOperation {
            guard
                let upcoming = upcomingOp.movies,
                let topRated = topRatedOp.movies,
                let popular  = popularOp.movies
                else {
                    debugPrint("There's an error")
                    completion()
                    return
            }
            
            self.movieSections[.upcoming] = upcoming
            self.movieSections[.topRated] = topRated
            self.movieSections[.popular]  = popular
            completion()
        }
        
        blockOp.addDependency(upcomingOp)
        blockOp.addDependency(topRatedOp)
        blockOp.addDependency(popularOp)
        
        OperationQueue().addOperations([upcomingOp, topRatedOp, popularOp], waitUntilFinished: false)
        OperationQueue.main.addOperation(blockOp)
    }
}
