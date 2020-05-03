//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

enum RedditAPI {
    static let scheme = "http"
    static let host = "www.reddit.com"
}

struct RedditRequest: Request {
    let responseType: ResponseType<ResponseData> = .json
    let contentType: String = "application/json"
    var after: String?
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = RedditAPI.scheme
        components.host = RedditAPI.host
        components.path = "/top/.json"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
        ]
        
        if let after = after, !after.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "after", value: after))
        }
        
        return components
    }
}
