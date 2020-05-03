//
//  CRUD.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol CRUD {
    associatedtype T
    
    func create(_ object: T)
    func read(id: String) -> T?
    func update(_ object: T)
    func delete(_ object: T) -> Bool
}
