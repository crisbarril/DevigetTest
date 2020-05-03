//
//  MockMasterViewNavigation.swift
//  TestProjectTests
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import Foundation
@testable import DevigetTest

class MockMasterViewNavigation {
    
}

extension MockMasterViewNavigation: MasterViewNavigation {
    func show(article: Article) {}
    func deleted(article: Article) {}
}
