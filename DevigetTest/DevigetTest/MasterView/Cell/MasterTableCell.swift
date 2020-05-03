//
//  MasterTableCell.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

class MasterTableCell: UITableViewCell, CellConfigurable {
    
    //MARK: UI Elements
    @IBOutlet weak var imgReadStatus: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblCreationDate: UILabel!
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lcTitleContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var stkContainer: UIStackView!
    
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var lblNumberOfComments: UILabel!
        
    private var viewModel: MasterTableCellViewModel?
    private var imageDownloader: ImageDownloader?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.article.readStatus.unsubscribe(self)
        imgReadStatus.isHidden = false
        imgReadStatus.alpha = 1.0
        imgThumbnail.isHidden = false
        imageDownloader?.cancel()
        lcTitleContainerHeight.constant = 60.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let labelHeight = lblTitle.text?.height(withConstrainedWidth: lblTitle.frame.width, font: lblTitle.font) {
            lcTitleContainerHeight.constant = labelHeight
        }
    }
    
    func populate(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? MasterTableCellViewModel else { return }
        
        self.viewModel = viewModel
        
        if let imageData = viewModel.article.thumbnailData {
            print("Loading image from local data")
            imgThumbnail.image = UIImage(data: imageData)
        } else if !viewModel.article.thumbnail.isEmpty {
            imageDownloader = ImageDownloader()
            imgThumbnail.showActivityIndicator()
            imageDownloader?.download(from: viewModel.article.thumbnail) { [weak self] image in
                print("Loading downloaded image")
                self?.viewModel?.article.thumbnailData = image?.pngData()
                DispatchQueue.main.async() {
                    self?.imgThumbnail.hideActivityIndicator()
                    self?.imgThumbnail.image = image
                }
            }
        }
        
        imgReadStatus.isHidden = viewModel.article.readStatus.value
        viewModel.article.readStatus.subscribe(self) { [weak self] (readStatus) in
            if readStatus {
                UIView.animate(withDuration: 0.75) {
                    self?.imgReadStatus.alpha = 0.0
                }
            }
        }

        lblAuthor.text = viewModel.article.author
        lblCreationDate.text = "\(viewModel.article.pastTime)"
        lblTitle.text = viewModel.article.title
        
        let commentsText = viewModel.article.comments == 1 ? "\(viewModel.article.comments) comment" : "\(viewModel.article.comments) comments"
        lblNumberOfComments.text = commentsText
        
        setNeedsLayout()
    }
    
    @IBAction func didTapDeletePostButton(_ sender: Any) {
        viewModel?.deleteButtonPressed()
    }
}
