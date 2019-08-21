//
//  DocumentHandler.swift
//  TWGiOS
//
//  Created by Samiksha on 22/03/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO

class DocumentHandler {
    
    static let shared = DocumentHandler()
    
    func saveToDocuments(image: UIImage, asset: ImageAsset, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let jpegData: Data = compress(image: image, maxFileSize: 1 , compression: 1.0, maxCompression: 0.6)!
        
        do {
            if FileManager.default.fileExists(atPath: asset.path.absoluteString) {
                try FileManager.default.removeItem(at: asset.path)
            }
            
            try jpegData.write(to: asset.path, options: .atomic)
            print(asset.path)
            completionHandler(true, nil)
        } catch {
            completionHandler(false, error)
        }
    }
    
    func saveJPEGToDocuments(image: UIImage, asset: ImageAsset, metadata: NSDictionary, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        guard let imageDest = CGImageDestinationCreateWithURL(asset.path as CFURL, kUTTypeJPEG, 1, nil) else {
            return
        }
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        let metadata = [kCGImageDestinationLossyCompressionQuality as String: 0.8] as CFDictionary
        CGImageDestinationAddImage(imageDest, cgImage, metadata)
        
        guard CGImageDestinationFinalize(imageDest) else {
            return
        }
        
        
        completionHandler(true, nil)
    }
    
    
    func compress(image: UIImage, maxFileSize: Int, compression: CGFloat = 1.0, maxCompression: CGFloat = 0.6) -> Data? {
        
        if let data = UIImageJPEGRepresentation(image, compression) {
            
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(data.count))
            
            if data.count > (maxFileSize * 1024 * 1024) && (compression > maxCompression) {
                let newCompression = compression - 0.1
                let compressedData = self.compress(image: image, maxFileSize: maxFileSize, compression: newCompression, maxCompression: maxCompression)
                return compressedData
            }
            return data
        }
        return nil
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
