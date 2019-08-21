//
//  ImageCropperService.swift
//  TWGiOS
//
//  Created by Ankita Porwal on 31/07/17.
//  Copyright © 2017 Coverati. All rights reserved.
//

import Foundation
import TOCropViewController

enum ImageCropperType {
    case circular, rectangular
}

struct ImageCropper {
    var type: ImageCropperType
}

class ImageCropperService: NSObject {
    fileprivate var image: UIImage!
    fileprivate var completionHandler: ((_ image: UIImage?) -> ())?
    fileprivate var cropViewController: TOCropViewController?
    
    init(_ image1: UIImage, _ completionHandler1: ((_ image: UIImage?) -> ())?) {
        super.init()
        image = image1
        completionHandler = completionHandler1
    }
    
    func showInViewController(_ vc: UIViewController, _ cropper: ImageCropper) {
        switch cropper.type {
        case .circular:
            cropViewController = TOCropViewController.init(croppingStyle: .circular, image: image)
        default:
            cropViewController = TOCropViewController.init(croppingStyle: .default, image: image)
            cropViewController?.aspectRatioPreset = .preset16x9
            cropViewController?.aspectRatioLockEnabled = true
            cropViewController?.aspectRatioPickerButtonHidden = true
        }
        cropViewController?.delegate = self
        vc.present(cropViewController!, animated: true, completion: nil)
    }
}

extension ImageCropperService: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            if self.completionHandler != nil {
                self.completionHandler!(image)
            }
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) { 
            if self.completionHandler != nil {
                self.completionHandler!(image)
            }
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
        cropViewController.dismiss(animated: true) {
            if self.completionHandler != nil {
                self.completionHandler!(self.image)
            }
        }
    }
}
