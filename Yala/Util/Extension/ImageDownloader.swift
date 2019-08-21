//
//  ImageDownloader.swift
//  Yala
//
//  Created by Ankita on 03/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    static var shared = ImageDownloader()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: ((Data?, URLResponse?, Error?) -> ())?) {
        
        getData(from: url) { data, response, error in
            guard let _data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            if completion != nil {
                completion!(data, response, error)
            }
        }
    }
}
