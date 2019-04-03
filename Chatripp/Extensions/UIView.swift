//
//  UIView.swift
//  GCP
//
//  Created by Famousming on 2018/12/17.
//  Copyright © 2018 fms.software. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func animateInSec( isHide:Bool, duration:Double = 0.3){
        
        if self.isHidden == isHide {
            return
        }
        
        self.isHidden = false
        self.alpha = isHide ? 1.0 : 0.0
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = isHide ? 0.0 : 1.0
            }) { (finished) in
                self.isHidden = isHide
            }
        }
    }
    
    func addOverlay(opacity: Float) {
        if let subLayers = self.layer.sublayers {
            for sublayer in subLayers {
                if sublayer.name == "blackOverlay" {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        let overlayLayer = CALayer()
        overlayLayer.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(opacity)).cgColor
        overlayLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width*2, height: self.bounds.height*2)
        overlayLayer.name = "blackOverlay"
        self.layer.addSublayer(overlayLayer)
    }
    
    func setShadowToBottomOnly() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setShadow() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
