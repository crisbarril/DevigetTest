//
//  MockArticlesPersistence.swift
//  TestProjectTests
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import Foundation
@testable import DevigetTest

struct MockArticlesPersistence: ArticlesPersistenceProtocol {
    var articles: Set<Article> = []
    
    func create(_ object: Article) {
        
    }
    
    func read(id: String) -> Article? {
        return nil
    }
    
    func update(_ object: Article) {
        
    }
    
    func delete(_ object: Article) -> Bool {
        return true
    }
    
    func save() {
        
    }
}
