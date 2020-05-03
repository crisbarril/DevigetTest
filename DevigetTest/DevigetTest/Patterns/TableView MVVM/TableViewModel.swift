//
//  TableViewModel.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol TableViewModel {
    func supportedCells() -> [CellConfigurable.Type]
    func numberOfSections() -> Int
    func numberOfRows(_ section: Int) -> Int
    func getRowViewModel(_ indexPath: IndexPath) -> RowViewModel?
    func cellIdentifier(viewModel: RowViewModel) -> String
}
