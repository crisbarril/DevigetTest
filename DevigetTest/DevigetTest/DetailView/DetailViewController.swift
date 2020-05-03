//
//  DetailViewController.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtTitle: UITextView!
    
    var viewModel: DetailViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    func inject(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initBinding()
    }
    
    //MARK: Private Method
    private func setupUI() {
        lblAuthor.text = ""
        txtTitle.text = "No article selected"
        imgPicture.image = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.saveImage))
        imgPicture.addGestureRecognizer(tap)
    }
    
    @objc private func saveImage() {
        if let image = imgPicture.image {
            imgPicture.showActivityIndicator()
            image.saveOnGallery { [weak self] (success, error) in
                if success {
                    self?.showInfoAlert(title: "Image Saved", message: "Image was successfully saved on gallery")
                }
                else if let error = error {
                    // Save photo failed with error
                    if error.code == 2047 {
                        self?.showInfoAlert(title: "Permission denied", message: error.localizedDescription, openSetting: true)
                    } else {
                        self?.showInfoAlert(title: "Error when saving image", message: error.localizedDescription)
                    }
                }
                else {
                    // Save photo failed with no error
                    self?.showInfoAlert(title: "Error when saving image", message: "Unknown error")
                }
                
                self?.imgPicture.hideActivityIndicator()
            }
        }
    }
    
    private func initBinding() {
        viewModel?.author.subscribe(self, { [weak self] (author) in
            self?.lblAuthor.text = author
        })
        
        viewModel?.picture.subscribe(self, { [weak self] (picture) in
            self?.imgPicture.image = picture
            self?.imgPicture.isHidden = picture == nil
        })
        
        viewModel?.title.subscribe(self, { [weak self] (title) in
            self?.txtTitle.text = title            
        })
    }
}
