//
//  ImageAsset.swift
//  TWGiOS
//
//  Created by Samiksha on 17/03/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import Foundation
import UIKit

class ImageAsset: NSObject {
    var path: URL!
    var name: String!
    
    override init() {
        super.init()
    }
    
    init(path: URL, name: String) {
        super.init()
        self.path = path
        self.name = name
    }
    
    init(withName name: String, parentDirectory directory: String) {
        super.init()
        self.name = name
        self.path = FileManager.default.getPathToDocumentDirectory(folderName: directory, withImageName: name)
    }
    
    func readFileFromFolder() -> UIImage? {
        var data: Data? = nil
        do {
            data = try Data(contentsOf: self.path)
            return UIImage(data:data!)!
        } catch {
            print ("ERROR!")
        }
        
        return nil
    }
    
    func dataFromFile() -> Data? {
        var data: Data? = nil
        do {
            data = try Data(contentsOf: self.path)
            return data
        } catch {
            print ("ERROR!")
        }
        return data
    }
    
    func base64String() -> String? {
        var data: Data? = nil
        do {
            data = try Data(contentsOf: self.path)
            return data?.base64EncodedString()
        } catch {
            print ("ERROR!")
        }
        
        return nil
    }
    
    func thumbnail(ofSize size: CGSize) -> UIImage? {
        let image = readFileFromFolder()
        var thumbnail: UIImage?
        if (image != nil) {
            thumbnail = DocumentHandler.shared.imageWithImage(image: image!, scaledToSize: size)
        }
        return thumbnail
    }
    
    func clearLocalData() {
        do {
            if path != nil {
                try  FileManager.default.removeItem(at: path)
            }
        } catch {
            print ("ERROR!")
        }
    }
}
