//
//  MockArticlesClient.swift
//  TestProjectTests
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import Foundation
@testable import DevigetTest

struct MockArticlesClient {
    
    let responseCount = 10
}

extension MockArticlesClient: NetworkClientProtocol {
    func getTopArticles(_ completion: @escaping ArticlesClosure) {
        var mockArticlesDTO = [ArticleDTO]()
        for i in 0..<responseCount {
            mockArticlesDTO.append(.init(id: "\(i)", title: "\(i)", author: "\(i)", entryDate: i, thumbnail: "", comments: i))
        }
        
        let articles = mockArticlesDTO.map({ Article($0) })
        completion(articles, Result.success)
    }
    
    func getNextPage(_ completion: @escaping ArticlesClosure) {
        
    }
}
