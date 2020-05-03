//
//  MasterViewNavigation.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol MasterViewNavigation: class {
    func show(article: Article)
    func deleted(article: Article)
}
