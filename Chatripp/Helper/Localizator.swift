//
//  Localizator.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/08.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit

typealias JSONDictionary = [String:Any?]

private class Localizator {
    
    static let shared = Localizator()
    
    lazy var content_en: JSONDictionary = {
        
        guard let path = Bundle.main.path(forResource: "Localization_en", ofType: "plist"), let json = NSDictionary(contentsOfFile: path) as? JSONDictionary else {
            fatalError("Localizable file NOT found")
        }
        return json
    }()
    
    lazy var content_fr: JSONDictionary = {
        
        guard let path = Bundle.main.path(forResource: "Localization_fr", ofType: "plist"), let json = NSDictionary(contentsOfFile: path) as? JSONDictionary else {
            fatalError("Localizable file NOT found")
        }
        return json
    }()
    
    func localize(string: String) -> String {
        
        let languagePrefix = Helper.getUserLocale()
        
        if languagePrefix == "en" {
            guard let localizedString = content_en[string] as? String else {
                //                fatalError("Missing translation for: \(string)")
                return string
            }
            return localizedString
        } else {
            guard let localizedString = content_fr[string] as? String else {
                //                fatalError("Missing translation for: \(string)")
                return string
            }
            return localizedString
        }
        
    }
    
    func localizeEn(string: String) -> String {
        guard let localizedString = content_en[string] as? String else {
            //            fatalError("Missing translation for: \(string)")
            return string
        }
        return localizedString
    }
    
    //    func getCurrentLangCode() -> String{
    //
    //        var languagePrefix = "en"
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        if let currentUser = appDelegate.currentUser {
    //            languagePrefix = currentUser.language == "fr" ? "fr" : "en"
    //        } else {
    //            let prefferedLanguage = Locale.preferredLanguages[0] as String
    //            print (prefferedLanguage) //en-US
    //
    //            let arr = prefferedLanguage.components(separatedBy: "-")
    //            languagePrefix = arr.first?.lowercased() == "fr" ? "fr" : "en"
    //        }
    //        return languagePrefix
    //    }
}

extension String {
    
    var localized: String {
        
        return Localizator.shared.localize(string: self)
    }
    
    var localizedEn: String {
        return Localizator.shared.localizeEn(string: self)
    }
}
