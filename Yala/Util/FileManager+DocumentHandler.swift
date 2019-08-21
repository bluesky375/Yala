//
//  FileManager+DocumentHandler.swift
//  TWGiOS
//
//  Created by Samiksha on 17/04/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import Foundation

extension FileManager {
    
    func clearAllFilesFromPath(path: URL) {
        do {
            try self.removeItem(at: path)
        } catch let error as NSError {
            print("\(error.debugDescription)")
        }
    }
    
    func getPathToDocumentDirectory(folderName: String) -> URL {
        let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first
        let dataPath = documentsURL?.appendingPathComponent(folderName)
        do {
            try self.createDirectory(atPath: (dataPath?.path)!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        return dataPath!
    }
    
    func getPathToDocumentDirectory(folderName: String, withImageName imageName: String?) -> URL {
        let folderPath = self.getPathToDocumentDirectory(folderName: folderName)
        return self.getActualFileUrl(withImageName: imageName, andDocumentDirectoryPath: folderPath)
    }
    
    func getActualFileUrl(withImageName imageName: String?, andDocumentDirectoryPath path: URL) -> URL {
        var fileURL = path
        if let imageName = imageName {
            fileURL = path.appendingPathComponent(imageName)
        }
        return fileURL
    }
}
