//
//  Constants.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/23.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit

public class Constants {
    
    static let colorBlueBG      = UIColor.init(rgb: 0x3425A7)
    static let colorBlueAC      = UIColor.init(rgb: 0x2225C7)
    
    static let colorRedBG       = UIColor.init(rgb: 0xFF657E)
    static let colorRedAC       = UIColor.init(rgb: 0xFF6592)
    static let colorRedLight    = UIColor.init(rgb:0xE73956)
    
    static let colorWhite       = UIColor.init(rgb: 0xFFFFFF)
    static let colorTransparent = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
    
    static let colorLightGray   = UIColor.init(rgb: 0xF4F4F4)
    static let colorGrayDark    = UIColor.init(rgb: 0x333333)
    static let colorGray        = UIColor.init(rgb: 0x777777)
    static let colorGreenBG     = UIColor.init(rgb: 0x20DF91)
    
    static let colorBlack       = UIColor.init(rgb: 0x25272D)
    
    static let dateFormatPost = "d MMM, yyyy"
    static let dateFormatDM = "d MMM"
}

enum TabBarItem : Int {
    case TabBarItemTrip = 0
    case TabBarItemChat = 1
    case TabBarItemPost = 2
    case TabBarItemProfile = 3
    case TabBarItemNotification = 4
}
