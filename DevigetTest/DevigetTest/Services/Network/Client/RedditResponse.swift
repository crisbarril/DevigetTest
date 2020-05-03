//
//  ArticlesResult.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    let data: Children
    
    struct Children: Codable {
        let children: [ArticleData]        
        let after: String?
        let before: String?
        
        struct ArticleData: Codable {
            let data: ArticleDTO
        }
    }
}

struct ArticleDTO: Codable {
    var id: String
    var title: String
    var author: String
    var entryDate: Int
    var thumbnail: String
    var comments: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case entryDate = "created"
        case thumbnail
        case comments = "num_comments"
    }
}
