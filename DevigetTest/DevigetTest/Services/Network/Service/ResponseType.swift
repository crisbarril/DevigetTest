//
//  ResponseType.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

enum ResponseType<T: Decodable> {
    case json
}

extension ResponseType {
    func decode(_ data: Data?) throws -> T? {
        guard let data = data else {
            return nil
        }
        
        switch self {
        case .json:
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
