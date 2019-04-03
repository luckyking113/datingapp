//
//  TripFilterFriendVC.swift
//  Chatripp
//
//  Created by KpStar on 3/3/19.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import MARKRangeSlider

protocol TripFilterFriendVCDelegate {
    
    func setNewFilter(isMale:Bool?, minAge: Int, maxAge: Int, nationalities:[String]?)
}

class TripFilterFriendVC: UIViewController, TripFilterNationVCDelegate {
    
    @IBOutlet weak var uiMale: UIView!
    @IBOutlet weak var uiFemale: UIView!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var chkMale: UIImageView!
    @IBOutlet weak var chkFemale: UIImageView!
    
    @IBOutlet weak var rangeAge: MARKRangeSlider!
    @IBOutlet weak var lblRangeTxt: UILabel!
    
    @IBOutlet weak var uiUnSelected: UIView!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var uiSelected: UIView!
    @IBOutlet weak var uiSelectedEdit: UIView!
    
    @IBOutlet weak var btnClearCountry: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    var isMale: Bool?
    var countries: [String] = []
    var delegate : TripFilterFriendVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        setupRangeSlider()
        setupUIGender()
        setupGender(gender: true)
        initCountries()
    }
    
    func initCountries() {
        
        self.addGesture(isWhat: true)
//        self.countries = []
        setupCountries()
    }
    
    func addGesture(isWhat: Bool) {
        
        let eTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editCountries))
        self.uiSelectedEdit.addGestureRecognizer(eTapGesture)
        if isWhat == true {
            self.uiUnSelected.addGestureRecognizer(eTapGesture)
        } else {
            self.uiUnSelected.removeGestureRecognizer(eTapGesture)
        }
    }
    
    func setSelectedCountries(countries: [String]) {
        
        self.countries = countries
        setupCountries()
    }
    
    func setupCountries() {
        
        if countries.count > 0 {
            self.uiSelected.isHidden = false
            self.uiSelectedEdit.isHidden = false
            self.lblSelected.text = String(format: "%d Nationalities Selected", countries.count)
            self.addGesture(isWhat: false)
            self.btnClearCountry.isHidden = false
        } else {
            self.addGesture(isWhat: true)
            self.uiSelectedEdit.isHidden = true
            self.uiSelected.isHidden = true
            self.btnClearCountry.isHidden = true
        }
    }
    
    func setupUIGender() {
        
        isMale = true
        let mTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.maleClicked))
        self.uiMale.addGestureRecognizer(mTapGesture)
        
        let fTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.femaleClicked))
        self.uiFemale.addGestureRecognizer(fTapGesture)
    }
    
    @objc func editCountries() {
        
        let filterCountryVC = self.storyboard?.instantiateViewController(withIdentifier: "TripFilterNationVC") as! TripFilterNationVC
        filterCountryVC.delegate = self
        filterCountryVC.selected = self.countries
        self.present(filterCountryVC, animated: true, completion: nil)
    }
    
    @objc func femaleClicked() {
        
        isMale = false
        self.setupGender(gender: false)
    }
    
    @objc func maleClicked() {
        
        isMale = true
        self.setupGender(gender: true)
    }
    
    func setupGender(gender: Bool) {
        
        if gender == true {
            uiMale.backgroundColor = Constants.colorGreenBG
            uiFemale.backgroundColor = Constants.colorLightGray
            lblMale.textColor = Constants.colorBlack
            lblFemale.textColor = Constants.colorGray
            chkMale.isHidden = false
            chkFemale.isHidden = true
        } else {
            uiFemale.backgroundColor = Constants.colorGreenBG
            uiMale.backgroundColor = Constants.colorLightGray
            lblFemale.textColor = Constants.colorBlack
            lblMale.textColor = Constants.colorGray
            chkFemale.isHidden = false
            chkMale.isHidden = true
        }
    }
    
    func setupRangeSlider() {

        rangeAge.setMinValue(1, maxValue: 6)
        rangeAge.setLeftValue(1, rightValue: 6)
        rangeAge.rangeImage = UIImage(named: "ic_range_track")
        rangeAge.addTarget(self, action: #selector(self.rangeSliderValueChanged), for: UIControl.Event.valueChanged)
        rangeAge.minimumDistance = 0.1
    }
    
    @IBAction func clearSelectedCountry(_ sender: Any) {
        
        self.countries = []
        initCountries()
    }
    
    @IBAction func closeBtn_clicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rangeSliderValueChanged() {
        self.updateRangeText()
    }
    
    func updateRangeText() {
        
        self.lblRangeTxt.text = String(format: "%d to %d", Int(self.rangeAge.leftValue * 10) , Int(self.rangeAge.rightValue * 10))
    }
    
    @IBAction func clickFilter(_ sender: UIButton) {
        self.delegate?.setNewFilter(isMale: self.isMale, minAge: Int(self.rangeAge.leftValue * 10), maxAge: Int(self.rangeAge.rightValue * 10), nationalities: self.countries)
        self.goBackVC()
    }
}
