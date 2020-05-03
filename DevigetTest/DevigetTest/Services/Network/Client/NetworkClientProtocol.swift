//
//  NetworkClientProtocol.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import Foundation

typealias ArticlesClosure = (_ articles: [Article]?, _ result: Result)->()

protocol NetworkClientProtocol {
    func getTopArticles(_ completion: @escaping ArticlesClosure)
    func getNextPage(_ completion: @escaping ArticlesClosure)
}
