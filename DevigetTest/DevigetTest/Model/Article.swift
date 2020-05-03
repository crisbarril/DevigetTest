//
//  Article.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

class Article: Codable {
    var id: String
    var title: String
    var author: String
    var entryDate: Int
    var thumbnail: String
    var thumbnailData: Data? = nil
    var comments: Int
    var readStatus = Observable<Bool>(value: false)
    
    var pastTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(entryDate))
        return date.getPastTimeString()
    }
    
    init(_ dto: ArticleDTO) {
        id = dto.id
        title = dto.title
        author = dto.author
        entryDate = dto.entryDate
        thumbnail = dto.thumbnail == "default" ? "" : dto.thumbnail 
        comments = dto.comments
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        author = try container.decode(String.self, forKey: .author)
        entryDate = try container.decode(Int.self, forKey: .entryDate)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        thumbnailData = try container.decode(Data?.self, forKey: .thumbnailData)
        comments = try container.decode(Int.self, forKey: .comments)
        readStatus.value = try container.decode(Bool.self, forKey: .readStatus)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
                
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
        try container.encode(entryDate, forKey: .entryDate)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(thumbnailData, forKey: .thumbnailData)
        try container.encode(comments, forKey: .comments)
        try container.encode(readStatus.value, forKey: .readStatus)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case entryDate = "created"
        case thumbnail
        case thumbnailData
        case comments = "num_comments"
        case readStatus
    }
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Article: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Article: CustomStringConvertible {
    var description: String {

        let description = """
        \n
            id: \(id)
            title: \(title)
            author: \(author)
            entryDate: \(entryDate)
            thumbnail: \(thumbnail)
            comments: \(comments)
            unreadStatus: \(readStatus.value)
        """
        
        return description
    }
}
