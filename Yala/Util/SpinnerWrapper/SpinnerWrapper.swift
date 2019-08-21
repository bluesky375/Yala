import Foundation
import UIKit
import SnapKit

class SpinnerWrapper {
    static let shared = SpinnerWrapper()
    var animator: CAAnimation {
        get {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = 2 * Double.pi
            rotationAnimation.duration = 1
            rotationAnimation.repeatCount = Float.infinity
            rotationAnimation.isRemovedOnCompletion = false
            return rotationAnimation
        }
    }
    var spinnerBackgroundView: UIView = UIView()
    let spinnerImageView = UIImageView()
    var isVisible = false
    
    init() {
        spinnerImageView.image = UIImage(named: "spinner_icon")
        
        spinnerBackgroundView.backgroundColor = UIColor.clear
        //spinnerBackgroundView.clipsToBounds = true
        //spinnerBackgroundView.layer.cornerRadius = 6
        spinnerBackgroundView.addSubview(spinnerImageView)
        
        spinnerImageView.layer.masksToBounds = false
       // spinnerImageView.layer.shadowColor = UIColor.lightGray.cgColor
        //spinnerImageView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        //spinnerImageView.layer.shadowOpacity = 0.8
        //spinnerImageView.layer.shadowRadius = 5
        
        spinnerImageView.snp.makeConstraints {(make) in
            make.height.equalTo(56)
            make.width.equalTo(56)
            make.center.equalToSuperview()
        }
    }
    
    static func showSpinner() {
        guard !(shared.isVisible) else {
            return
        }
        let callShowAcitvity = {
            let window =  UIApplication.shared.keyWindow
            if window != nil {
                shared.isVisible = true
                shared.showActivityIndicator(inView: window!)
            }
        }
        
        if !(Thread.isMainThread) {
            DispatchQueue.main.async {
                callShowAcitvity()
            }
        } else {
            callShowAcitvity()
        }
    }
    
    func showActivityIndicator(inView view: UIView) {
        view.addSubview(spinnerBackgroundView)
        view.bringSubview(toFront: spinnerBackgroundView)
        view.isUserInteractionEnabled = false
        
        spinnerImageView.layer.add(animator, forKey: nil)
        spinnerBackgroundView.snp.makeConstraints {(make) in
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.center.equalToSuperview()
        }
    }
    
    static func hideSpinnerView() {
        guard shared.isVisible else {
            return
        }
        let callHideIndicator = {
            let window =  UIApplication.shared.keyWindow
            if window != nil {
                shared.isVisible = false
                shared.hideActivityIndicator(fromView: window!)
            }
        }
        if !(Thread.isMainThread) {
            DispatchQueue.main.async {
                callHideIndicator()
            }
        } else {
            callHideIndicator()
        }
    }
    
    func hideActivityIndicator(fromView view: UIView) {
        spinnerBackgroundView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

