//
//  UITableviewExtension.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

extension UITableView {
    func registerXibCell(nibName:String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: nibName)
    }
    
    func registerStoryboardCell(_ tableViewCell: UITableViewCell.Type) {
        register(tableViewCell, forCellReuseIdentifier: tableViewCell.reuseIdentifier)
    }
    
    func registerHeaderViewWith(nibName:String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: nibName)
    }
}
