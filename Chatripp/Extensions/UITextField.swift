//
//  UITextField.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/23.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

extension UITextField {

    func setPlaceHolderColor(with : UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",attributes: [NSAttributedString.Key.foregroundColor: with])
    }
}
