//
//  ImageView.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import UIKit

typealias ImageDownloaderClosure = ((UIImage?) -> ())

struct ImageDownloader {
    
    var task: URLSessionDataTask?
    
    mutating func download(from url: URL, completion: @escaping ImageDownloaderClosure) {
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
            }
            DispatchQueue.main.async() {
                completion(image)
            }
        }
        
        task?.resume()
    }
    
    mutating func download(from link: String, completion: @escaping ImageDownloaderClosure) {
        guard let url = URL(string: link) else { return }
        download(from: url, completion: completion)
    }
    
    func cancel() {
        task?.cancel()
    }
}
