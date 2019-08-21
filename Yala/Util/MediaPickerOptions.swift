//
//  MediaPickerHelper.swift
//  TWGiOS
//
//  Created by Ankita Porwal on 18/12/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import Foundation
import UIKit

struct MediaPickerOptions : OptionSet {
    let rawValue: Int
    
    static let singleSelect  = MediaPickerOptions(rawValue: 1 << 0)
    static let multiSelect = MediaPickerOptions(rawValue: 1 << 1)
    static let circularCrop  = MediaPickerOptions(rawValue: 1 << 2)
    static let rectangularCrop = MediaPickerOptions(rawValue: 1 << 3)
}

class MediaPickerHelper {
    fileprivate let attachmentActionSheetBuilder = ActionSheetBuilder()
    fileprivate var cameraRollService: CameraRollService!
    
    init(_ options: MediaPickerOptions) {
        cameraRollService = options.contains(.multiSelect) ? CameraRollService(type: .multiSelect) : CameraRollService(type: .singleSelect)
        
        if options.contains(.circularCrop) {
            cameraRollService.cropper = ImageCropper(type: .circular)
        } else if options.contains(.rectangularCrop) {
            cameraRollService.cropper = ImageCropper(type: .rectangular)
        }
    }
    
    func showImageUploadOptionsIn(_ viewController: UIViewController, _ popoverRect: CGRect?, _ popoverSourceView: UIView?, _ assetStoragePath: String, _ filename: String, completionHandler: @escaping (_ success: Bool, _ error: Error?, _ response: [ImageAsset]?) -> ()) {
        
        attachmentActionSheetBuilder.galleryPicker = { [unowned self] in
            self.cameraRollService.photosFromGallery(inViewController: viewController, assetSavePath: assetStoragePath, fileName: filename) { (success, error, response) in
                completionHandler(success, error, response)
            }
        }
        
        attachmentActionSheetBuilder.cameraPicker = { [unowned self] in
            self.cameraRollService.photoFromCamera(onViewController: viewController, assetSavePath: assetStoragePath, fileName: filename) { (success, error, response) in
                completionHandler(success, error, response)
            }
        }
        
        attachmentActionSheetBuilder.buildMenuItems(forType: .photoPicker, inViewController: viewController, popoverRect, popoverSourceView)
    }
}
