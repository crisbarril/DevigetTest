//
//  TableViewCell.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Generated cell identifier derived from class name
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
