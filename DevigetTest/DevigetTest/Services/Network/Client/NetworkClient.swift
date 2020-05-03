//
//  NetworkClient.swift
//  NetworkLayer
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

class NetworkClient {
    private let router = Router()    
    private var lastSearch: String = ""
}

extension NetworkClient: NetworkClientProtocol {
    func getTopArticles(_ completion: @escaping ArticlesClosure) {
        let request = RedditRequest()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.router.request(from: request) { [weak self] (response, result) in
                self?.lastSearch = response?.data.after ?? ""
                let articles = response?.data.children.map({ Article($0.data) })
                
                DispatchQueue.main.async {
                    completion(articles, result)
                }
            }
        }
    }
    
    func getNextPage(_ completion: @escaping ArticlesClosure) {
        let request = RedditRequest(after: lastSearch)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.router.request(from: request) { [weak self] (response, result) in
                self?.lastSearch = response?.data.after ?? ""
                let articles = response?.data.children.map({ Article($0.data) })
                
                DispatchQueue.main.async {
                    completion(articles, result)
                }
            }
        }
    }
}
