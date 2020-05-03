//
//  ArticlesPersistenceProtocol.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import Foundation

protocol ArticlesPersistenceProtocol {
    var articles: Set<Article> { get set }
    
    func create(_ object: Article)
    func read(id: String) -> Article?
    func update(_ object: Article)
    func delete(_ object: Article) -> Bool
    func save()
}
