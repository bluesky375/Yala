//
//  CameraRollService.swift
//  TWGiOS
//
//  Created by Samiksha on 27/02/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

enum GalleryType {
    case singleSelect
    case multiSelect
}

class CameraRollService: NSObject {
    
    private var galleryPicker: DKImagePickerController!
    fileprivate var cameraImagePicker: UIImagePickerController!
    var imageAssets = [ImageAsset]()
    
    private var galleryType: GalleryType!
    var cropper: ImageCropper?
    fileprivate var parentViewController: UIViewController!
    fileprivate var imageCroppingService: ImageCropperService?
    
    private var assets: [DKAsset]?
    fileprivate var num: Double?
    fileprivate var folderName: String!
    fileprivate var fileName: String!
    fileprivate var photoFromCameraCompletionHandler:((_ success: Bool, _ error: Error?, _ response: [ImageAsset]?)->())?
    
    init(type galleryType1: GalleryType) {
        super.init()
        galleryType = galleryType1
    }
    
    init(type galleryType1: GalleryType, _ cropper1: ImageCropper) {
        super.init()
        galleryType = galleryType1
        cropper = cropper1
    }
    
    fileprivate func cropImage(_ image: UIImage, inViewControler viewController: UIViewController, completion:@escaping (_ image: UIImage) -> ()) {
        guard cropper != nil  else {
            assert(false)
            return
        }
        
        imageCroppingService = ImageCropperService.init(image) { (croppedImage) in
            completion(croppedImage!)
        }
        DispatchQueue.main.async {
            self.imageCroppingService?.showInViewController(viewController, self.cropper!)
        }
    }
    
    private func showImagePicker(inViewController viewController: UIViewController,
                                 assetSavePath directory: String,
                                 fileName: String,
                                 completionHandler:  ((_ success: Bool, _ error: Error?, _ response: [ImageAsset]?)->())?) {
        // galleryPicker.defaultSelectedAssets = self.assets
        
        galleryPicker.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            switch self.galleryType! {
            case .singleSelect:
                self.imageAssets = []
            default:
                break
            }
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                
                for asset in assets {
                    asset.fetchOriginalImageWithCompleteBlock({[unowned self] (image, info) in
                        
                        let completion: (_ image: UIImage) ->() = {[unowned self] (newImage) in
                            let imageName: String = self.getImageName()
                            let imageItem: UIImage = newImage as UIImage
                            let attachmentAsset = ImageAsset.init(withName: imageName, parentDirectory: directory)
                            
                            DocumentHandler.shared.saveToDocuments(image: imageItem, asset: attachmentAsset) { [unowned self] (success, error) in
                                if success {
                                    self.imageAssets.append(attachmentAsset)
                                    if (assets.count == self.imageAssets.count) && completionHandler != nil {
                                        DispatchQueue.main.async {
                                            completionHandler!(true, nil, self.imageAssets)
                                        }
                                    } else {
                                        self.num = self.num! + 1
                                    }
                                } else {
                                    completionHandler!(false, nil, nil)
                                }
                            }
                        }
                        
                        if self.galleryType == .singleSelect && image != nil && self.cropper != nil {
                            self.cropImage(image!, inViewControler: viewController, completion: { (newImage) in
                                completion(newImage)
                            })
                        } else if image != nil {
                            completion(image!)
                        } else {
                            completionHandler!(false, nil, nil)
                        }
                    })
                }
            }
        }
        viewController.present(galleryPicker, animated: true)
    }
    
    func photosFromGallery(inViewController viewController: UIViewController,
                           assetSavePath folderName: String,
                           fileName: String,
                           completionHandler: @escaping (_ success: Bool, _ error: Error?, _ response: [ImageAsset]?) -> ()) {
        resetPicker(withFolderName: folderName, fileName: fileName, parentViewController: viewController)
        
        if galleryPicker == nil {
            galleryPicker = DKImagePickerController()
        }
        
        galleryPicker.sourceType = .photo
        
        switch galleryType! {
        case .singleSelect:
            galleryPicker.singleSelect = true
        default:
            break
        }
        showImagePicker(inViewController: viewController, assetSavePath: folderName, fileName: fileName, completionHandler: completionHandler)
    }
    
    func photoFromCamera(onViewController viewController: UIViewController,
                         assetSavePath folderName: String,
                         fileName: String,
                         completionHandler: @escaping (_ success: Bool, _ error: Error?, _ response: [ImageAsset]?) -> ()) {
        resetPicker(withFolderName: folderName, fileName: fileName, parentViewController: viewController)
        
        cameraImagePicker =  UIImagePickerController()
        cameraImagePicker.sourceType = .camera
        cameraImagePicker.delegate = self
        
        photoFromCameraCompletionHandler = completionHandler
        
        viewController.present(cameraImagePicker, animated: true, completion: nil)
    }
    
    private func resetPicker(withFolderName folderName: String, fileName: String, parentViewController: UIViewController) {
        self.folderName = folderName
        self.fileName = fileName
        self.parentViewController = parentViewController
        self.imageAssets = []
        num = 1
    }
    
    func requestCameraAuthorization(inViewController viewController: UIViewController, completion: ((_ authorized: Bool)->())?) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                if completion != nil {
                    completion!(response)
                }
            }
        }
    }
    
    func requestPhotosAuthorization(inViewController viewController: UIViewController, completion: ((_ authorized: Bool)->())?) {
        PHPhotoLibrary.requestAuthorization({status in
            DispatchQueue.main.async {
                if completion != nil {
                    if status == .authorized {
                        completion!(true)
                    }else {
                        completion!(false)
                    }
                }
            }
        })
    }
    
    func getImageName() -> String {
        switch galleryType! {
        case .singleSelect:
            return self.fileName
        case .multiSelect:
            return self.fileName + "-\(self.num!).jpeg"
        }
    }
}

extension CameraRollService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImagePicker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global(qos: .background).async { [unowned self] in
            
            let completion: (_ image: UIImage, _ info: NSDictionary) ->() = {[unowned self] (newImage, info1) in
                let imageName: String = self.getImageName()
                let image: UIImage = newImage
                _ = info1[UIImagePickerControllerMediaMetadata] as! NSDictionary
                
                let attachmentAsset = ImageAsset.init(withName: imageName, parentDirectory: self.folderName)
                
                DocumentHandler.shared.saveToDocuments(image: image, asset: attachmentAsset, completionHandler: {[unowned self] (success, error) in
                    if success {
                        self.imageAssets.append(attachmentAsset)
                        
                        if self.photoFromCameraCompletionHandler != nil {
                            DispatchQueue.main.async {
                                self.photoFromCameraCompletionHandler!(true, nil, self.imageAssets)
                            }
                        } else {
                            self.num = self.num! + 1
                        }
                    } else {
                        self.photoFromCameraCompletionHandler!(false, nil, nil)
                    }
                })
            }
            
            let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            if self.cropper != nil {
                self.cropImage(image, inViewControler: self.parentViewController, completion: { (newImage) in
                    completion(newImage, info as NSDictionary)
                })
            } else {
                completion(image, info as NSDictionary)
            }
        }
    }
}
