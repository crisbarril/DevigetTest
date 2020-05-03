//
//  ViewController.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isHorizontallyRegular: Bool {
        return traitCollection.horizontalSizeClass == .regular
    }
    
    // MARK: UIAlertController
    func showInfoAlert(title: String, message: String, openSetting: Bool = false) {
        var actions = [UIAlertAction]()
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default)
        actions.append(acceptAction)
        
        if openSetting {
            let requestAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
            
            actions.append(requestAction)
        }
        
        showAlert(title: title, message: message, actions: actions)
    }
    
    private func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
