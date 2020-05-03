//
//  Image.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Photos
import UIKit

extension UIImage {
    
    typealias SaveOnGalleryClosure = ((Bool, Error?) -> Void)
    
    func saveOnGallery(completion: @escaping SaveOnGalleryClosure) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.save(completion: completion)
                } else {
                    completion(false, nil)
                }
            })
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: self)
            }, completionHandler: { success, error in
                completion(success, error)
            })
        }
    }
    
    private func save(completion: @escaping SaveOnGalleryClosure) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        }, completionHandler: { success, error in
            completion(success, error)
        })
    }
}
