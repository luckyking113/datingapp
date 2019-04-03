//
//  CTTabBarVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/24.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class CTTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        initTabBar()
    }
    
    func initTabBar() {
        
        self.tabBar.items![0].image = UIImage(named: "tab_icon_destination_normal")
        self.tabBar.items![0].selectedImage = UIImage(named: "tab_icon_destination_selected")
        
        self.tabBar.items![1].image = UIImage(named: "tab_icon_chat_normal")
        self.tabBar.items![1].selectedImage = UIImage(named: "tab_icon_chat_selected")

        self.tabBar.items![2].image = UIImage(named: "tab_icon_add")
        self.tabBar.items![2].selectedImage = UIImage(named: "tab_icon_add")

        self.tabBar.items![3].image = UIImage(named: "tab_icon_profile_normal")
        self.tabBar.items![3].selectedImage = UIImage(named: "tab_icon_profile_selected")

        self.tabBar.items![4].image = UIImage(named: "tab_icon_notification_normal")
        self.tabBar.items![4].selectedImage = UIImage(named: "tab_icon_notification_selected")

//        self.tabBar.tintColor = UIColor
        self.tabBar.unselectedItemTintColor = UIColor.init(rgb: 0x25272D)
        
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
    }
    
}

extension CTTabBarVC : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let item = self.viewControllers?.firstIndex(of: viewController)
        if item == TabBarItem.TabBarItemPost.rawValue {
            // click Center Add tab
            let postPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPhotosVC") as! AddPhotosVC
            
            self.navigationController?.pushViewController(postPhotoVC, animated: true)
//            self.present(postPhotoVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
