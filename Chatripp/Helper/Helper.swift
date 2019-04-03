//
//  Helper.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/24.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MBProgressHUD

public class Helper {
    
    static let appAlertTitle = "Green Nomad"
    
    static let sharedInstance : Helper = {
        
        let instance = Helper()
        return instance
    }()
    
    
    static func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func showAlert(target: UIViewController, title:String, message: String, completion: (()->())?=nil){
        
        let _title = title == "" ?  appAlertTitle : title
        
        let alert = UIAlertController(title: _title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            if(completion != nil){
                completion!()
            }
        }
        alert.addAction(okAction)
        target.present(alert, animated: true, completion: nil)
    }
    
    static func showLoading(target: UIViewController){
        let hub = MBProgressHUD.showAdded(to: target.view, animated: true)
        hub.bezelView.color = Constants.colorWhite
        hub.contentColor = Constants.colorBlueBG
        hub.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
    }
    
    static func hideLoading(target: UIViewController){
        MBProgressHUD.hide(for: target.view, animated: true)
    }
    
    static func thumbnailImage() -> UIImage {
        return UIImage(named: "bg_thumbnail")!
    }
    
    static func setUserLocale(locale: String) {
        UserDefaults.standard.set(locale, forKey: mUserLocale)
        
    }
    static func getUserLocale() -> String {
        
        var languagePrefix = "en"
        
        if let language = UserDefaults.standard.string(forKey: mUserLocale) {
            languagePrefix = language
        } else {
            let prefferedLanguage = Locale.preferredLanguages[0] as String
            print (prefferedLanguage) //en-US
            
            let arr = prefferedLanguage.components(separatedBy: "-")
            languagePrefix = arr.first?.lowercased() == "fr" ? "fr" : "en"
        }
        
        /// There is only EN now, let's remove this line lator.
        languagePrefix = "en"
        
        return languagePrefix
    }

}
