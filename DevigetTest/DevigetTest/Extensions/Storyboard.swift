//
//  Storyboard.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

extension UIStoryboard {
  // MARK: - Storyboards
  private static var main: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }

  // MARK: - View Controllers
    static func instantiateMasterViewController(viewModel: MasterViewModel) -> MasterViewController {
        let masterViewController = main.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController
        masterViewController.viewModel = viewModel
        
        return masterViewController
    }
    
    static func instantiateDetailViewController(viewModel: DetailViewModel) -> DetailViewController {
        let detailViewController = main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.viewModel = viewModel
        
        return detailViewController
    }
}
