//
//  View.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: ActivityIndicatorView
    private var mediumActivityIndicator: UIActivityIndicatorView {
        get {
            return (subviews.first { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView ?? UIActivityIndicatorView(style: .medium)
        }
    }
    
    private var largeActivityIndicator: UIActivityIndicatorView {
        get {
            return (subviews.first { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView ?? UIActivityIndicatorView(style: .large)
        }
    }
    
    func showActivityIndicator(_ style: UIActivityIndicatorView.Style = .medium) {
        let indicator = style == .medium ? mediumActivityIndicator : largeActivityIndicator
        
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        OperationQueue.main.addOperation({ () -> Void in
            self.addSubview(indicator)
        })
    }
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation({ () -> Void in
            self.mediumActivityIndicator.stopAnimating()
            self.largeActivityIndicator.stopAnimating()
        })
    }    
}
