//
//  CellConfigurable.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

protocol CellConfigurable: UITableViewCell {
    func populate(viewModel: RowViewModel)
}
