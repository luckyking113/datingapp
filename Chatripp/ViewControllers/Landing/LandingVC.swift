//
//  LandingVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/23.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func clickLogin(_ sender: Any) {        
        
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        self.navigationController?.pushViewController(signInVC!, animated: true)
    }
    
    @IBAction func clickCreateAccount(_ sender: Any) {
        
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC")
        self.navigationController?.pushViewController(signupVC!, animated: true)
    }
    
}
