//
//  MasterTableCellViewModel.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

struct MasterTableCellViewModel: RowViewModel, ViewModelPressible {
    let article: Article
    
    var cellPressed: (() -> ())
    var deleteButtonPressed: (() -> ())
}
