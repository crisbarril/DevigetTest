//
//  RowViewModel.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol RowViewModel {
    
}

/// Conform this protocol to handles user press action
protocol ViewModelPressible {
    var cellPressed: (() -> ()) { get set }
}
