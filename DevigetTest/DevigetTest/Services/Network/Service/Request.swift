//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol Request {
    associatedtype Response: Codable
    
    var urlComponents: URLComponents { get }
    var contentType: String { get }
    var responseType: ResponseType<Response> { get }
}
