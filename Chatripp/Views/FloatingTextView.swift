//
//  FloatingTextView.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/23.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

protocol FloatingTextViewDelegate {
    
    func didTextFieldChange (text: String)
    func didEndEditing()
}

class FloatingTextView: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    var type : SIGNUPTEXTTYPE!
    var delegate : FloatingTextViewDelegate?
    
    override init(frame: CGRect) {
        // Init from Code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // for using Interface Builder
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FloatingTextView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setValues(title: String, txtString : String, type : SIGNUPTEXTTYPE) {

        self.lblTitle.text = title
        self.txtInput.text = txtString
        self.type = type
        
        self.txtInput.isSecureTextEntry = type == .PASSWORD
        self.txtInput.becomeFirstResponder()
        self.txtInput.delegate = self
    }
    
    @IBAction func didTextEditingChanged(_ sender: UITextField) {
        self.delegate?.didTextFieldChange(text: sender.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.didEndEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didEndEditing()
    }
}
