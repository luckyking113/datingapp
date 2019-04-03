//
//  SigninVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/24.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class SigninVC: UIViewController {

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var floatingView: FloatingTextView!
    @IBOutlet weak var stackFieldViews: UIStackView!

    var selectedType : SIGNUPTEXTTYPE = .EMAIL
    let labelStrs = ["first name", "last name", "email", "password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView(){
        self.floatingView.isHidden = true
        self.floatingView.delegate = self
    }

    @IBAction func clickClose(_ sender: Any) {
        
        self.goBackVC()
    }
    
    @IBAction func clickSignIn(_ sender: Any) {
        
        self.signInWithEmail()
    }
    
    @IBAction func clickInputBtn(_ sender: UIButton) {
        
        let cPoint = sender.convert(sender.center, to: self.view)
        self.floatingView.frame = CGRect(x: 35, y: Int(cPoint.y - 52), width: Int(self.view.frame.width) - 70, height: 70)
        self.floatingView.animateInSec(isHide: false, duration: 0.3)
        self.stackFieldViews.alpha = 0.3
        self.selectedType = SIGNUPTEXTTYPE(rawValue: sender.tag)!
        let txt = (sender.titleLabel?.text!)!
        
        self.floatingView.setValues(title: labelStrs[sender.tag], txtString: txt == labelStrs[sender.tag] ? "" : txt , type: self.selectedType)
    }
}

extension SigninVC: FloatingTextViewDelegate {
    func didTextFieldChange(text: String) {
        
        switch self.selectedType {
        case .EMAIL:
            self.btnEmail.setTitle(text.isEmpty ? labelStrs[2] : text, for: .normal)
            break
        case .PASSWORD:
            self.txtPassword.text = text.isEmpty ? labelStrs[3] : text
            self.btnPassword.setTitle(text.isEmpty ? labelStrs[2] : "", for: .normal)
            break
        default:
            break
        }
    }
    
    func didEndEditing() {
        
        self.floatingView.animateInSec(isHide: true, duration: 0.3)
        self.stackFieldViews.alpha = 1
    }
}

extension SigninVC {
    // SignIn with Email
    
    func signInWithEmail() {
		let email = (btnEmail.titleLabel?.text ?? "") == labelStrs[2] ? "" : (btnEmail.titleLabel?.text ?? "")
		let password = (txtPassword.text ?? "") == labelStrs[3] ? "" : (txtPassword.text ?? "")
        
        if  email.isEmpty || password.isEmpty {
            Helper.showAlert(target: self, title: "", message: "Please insert all fields.")
            return
        }
        
        if !Helper.isValidEmail(email: email) {
            Helper.showAlert(target: self, title: "", message: "Please input correct email address.")
            return
        }
        
        Helper.showLoading(target: self)
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            
            Helper.hideLoading(target: self)
            
            if user != nil {
				(UIApplication.shared.delegate as! AppDelegate).configureChannel()
				
                UserManager.sharedInstance.initWithPFUser(pfUser: user!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setRootWithTabVC()
            } else {
                Helper.showAlert(target: self, title: "Login failed", message: error?.localizedDescription ?? "Please try again.")
            }
        }
    }
}
