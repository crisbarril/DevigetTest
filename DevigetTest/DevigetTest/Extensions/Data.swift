//
//  Data.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

extension Data {
    
    /**
    A function that create a Data object from a String type using UTF-8 decoding.
    
    - Author:
    Cristian Barril
    
    - parameters:
       - from: String to convert to Data
     
     - returns:
        - Data object
    */
    init(fromString string: String) {
        self.init(string.utf8)
    }

    /**
    A function that convert a Data object into a String type using UTF-8 encoding
    
    - Author:
    Cristian Barril
    
     - returns:
        - String instance or nil
    */
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
