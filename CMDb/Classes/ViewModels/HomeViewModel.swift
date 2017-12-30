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
        
        OperationQueue().addOperations([upcomingOp, topRatedOp, popularOp], waitUntilFinished: true)
        
        movieSections[.upcoming] = upcomingOp.movies
        movieSections[.topRated] = topRatedOp.movies
        movieSections[.popular]  = popularOp.movies
        
        OperationQueue.main.addOperation {
            completion()
        }
    }
}
