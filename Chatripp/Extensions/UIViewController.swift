//
//  UIViewController.swift
//  GCP
//
//  Created by Famousming on 2018/12/25.
//  Copyright © 2018 fms.software. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func goBackVC()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func backToRootVC() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
