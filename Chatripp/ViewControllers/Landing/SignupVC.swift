//
//  SignupVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/23.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

enum SIGNUPTEXTTYPE : Int{
    case FIRSTNAME = 0
    case LASTNAME  = 1
    case EMAIL     = 2
    case PASSWORD  = 3
}

class SignupVC: UIViewController {

    @IBOutlet weak var btnFirstName: UIButton!
    @IBOutlet weak var btnLastName: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var floatingView: FloatingTextView!
    @IBOutlet weak var stackFieldViews: UIStackView!
    
    var selectedType : SIGNUPTEXTTYPE = .FIRSTNAME
    let labelStrs = ["first name", "last name", "email", "password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupView(){
        
        self.floatingView.isHidden = true
        self.floatingView.delegate = self
    }
    
    @IBAction func clickClose(_ sender: Any) {
        
        self.goBackVC()
    }
    
    @IBAction func clickCreateAccount(_ sender: Any) {
        
        self.signUpWithEmail()
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

extension SignupVC: FloatingTextViewDelegate {
    
    func didTextFieldChange(text: String) {
        
        switch self.selectedType {
            case .FIRSTNAME:
                self.btnFirstName.setTitle(text.isEmpty ? labelStrs[0] : text, for: .normal)
                break
            case .LASTNAME:
                self.btnLastName.setTitle(text.isEmpty ? labelStrs[1] : text, for: .normal)
                break
            case .EMAIL:
                self.btnEmail.setTitle(text.isEmpty ? labelStrs[2] : text, for: .normal)
                break
            case .PASSWORD:
                self.txtPassword.text = text.isEmpty ? labelStrs[3] : text
                self.btnPassword.setTitle(text.isEmpty ? labelStrs[2] : "", for: .normal)
                break
        }
    }
    
    func didEndEditing() {
        self.floatingView.animateInSec(isHide: true, duration: 0.3)
        self.stackFieldViews.alpha = 1
    }
}

extension SignupVC {
    
    // Signup With Email
    func signUpWithEmail() {
        let firstname = (btnFirstName.titleLabel?.text ?? "") == labelStrs[0] ? "" : (btnFirstName.titleLabel?.text ?? "")
        let lastname = (btnLastName.titleLabel?.text ?? "") == labelStrs[1] ? "" : (btnLastName.titleLabel?.text ?? "")
        let email = (btnEmail.titleLabel?.text ?? "") == labelStrs[2] ? "" : (btnEmail.titleLabel?.text ?? "")
        let password = (txtPassword.text ?? "") == labelStrs[3] ? "" : (txtPassword.text ?? "")
        
        if firstname.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty {
            Helper.showAlert(target: self, title: "", message: "Please insert all fields.")
            return
        }
        
        if !Helper.isValidEmail(email: email) {
            Helper.showAlert(target: self, title: "", message: "Please input correct email address.")
            return
        }
        
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        Helper.showLoading(target: self)
        user.signUpInBackground { (success, error) in
            
            Helper.hideLoading(target: self)
            
            if success {
                
                Helper.showLoading(target: self)
				
				(UIApplication.shared.delegate as! AppDelegate).configureChannel()
                
                let profile = PFObject(className: DBNames.profile)
                profile[DBNames.profile_userObjId] = user.objectId
                profile[DBNames.profile_firstname] = firstname
                profile[DBNames.profile_lastname] = lastname
                profile[DBNames.profile_settingprivate] = false
                profile[DBNames.profile_restrictfollow] = false
                profile.saveInBackground(block: { (success, error) in

                    Helper.hideLoading(target: self)
                    if success {
                        
                        UserManager.sharedInstance.initWithPFUser(pfUser: user)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.setRootWithTabVC()
                    } else {
                        
                        Helper.showAlert(target: self, title: "SignUp Failed", message: error?.localizedDescription ?? "Please try again.")
                    }
                })
            } else {
                
                Helper.showAlert(target: self, title: "SignUp Failed", message: error?.localizedDescription ?? "Please try again.")
            }
        }
    }
}
