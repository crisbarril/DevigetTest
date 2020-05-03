//
//  ArticlesPersistence.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

class ArticlesPersistence {
    
    static let shared = ArticlesPersistence()
    
    // Prevents instantiation
    private init() {
        articles = persistedArticles
    }
    
    @UserDefault("persistedArticles", defaultValue: [])
    private var persistedArticles: Set<Article>
    
    var articles: Set<Article> = []
    
    func save() {
        persistedArticles = articles
    }
}

// MARK: CRUD methods
extension ArticlesPersistence: CRUD {
    typealias T = Article
        
    func create(_ object: T) {
        articles.insert(object)
    }
    
    func read(id: String) -> T? {
        return articles.first(where: { $0.id == id })
    }
    
    func update(_ object: T) {
        if delete(object) {
            create(object)
        }
    }
    
    @discardableResult
    func delete(_ object: T) -> Bool {
        let profilesCount = articles.count
        articles = articles.filter({ $0 != object })
        return profilesCount > articles.count
    }
}
