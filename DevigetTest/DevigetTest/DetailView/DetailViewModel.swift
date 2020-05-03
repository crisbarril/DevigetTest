//
//  DetailViewModel.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

class DetailViewModel {
    
    private var selectedArticle: Article?
    private var imageDownloader: ImageDownloader?
    
    let author = Observable<String>(value: "")
    let picture = Observable<UIImage?>(value: nil)
    let title = Observable<String>(value: "")

    func inject(selectedArticle: Article) {
        self.selectedArticle = selectedArticle
        
        author.value = selectedArticle.author
        title.value = selectedArticle.title
        
        if let imageData = selectedArticle.thumbnailData {
            print("Loading image from local data")
            picture.value = UIImage(data: imageData)
        } else if !selectedArticle.thumbnail.isEmpty {
            imageDownloader = ImageDownloader()
            imageDownloader?.download(from: selectedArticle.thumbnail) { [weak self] image in
                print("Loading downloaded image ")
                self?.selectedArticle?.thumbnailData = image?.pngData()
                
                DispatchQueue.main.async() {
                    self?.picture.value = image
                }
            }
        } else {
            picture.value = nil
        }
    }
    
    func deleted(article: Article) {
        if selectedArticle == article {
            author.value = ""
            picture.value = nil
            title.value = ""
        }
    }
}
