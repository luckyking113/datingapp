//
//  TripFilterNationVC.swift
//  Chatripp
//
//  Created by KpStar on 3/3/19.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

protocol TripFilterNationVCDelegate: class {
    
    func setSelectedCountries( countries: [String])
}

class TripFilterNationVC: UIViewController {

    @IBOutlet weak var tvCountry: UITableView!
    @IBOutlet weak var uiBlur: UIView!
    
    var countries: [String] = []
    var selected: [String]?
    weak var delegate: TripFilterNationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvCountry.delegate = self
        tvCountry.dataSource = self
        setupUIView()
        setupTableView()
    }
    
    func setupTableView() {
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        countries.sort()
        tvCountry.reloadData()
    }
    
    func setupUIView() {
        
        let grLayer = CAGradientLayer()
        grLayer.frame = uiBlur.bounds
        grLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        grLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        grLayer.colors = [Constants.colorWhite.cgColor,
                          Constants.colorTransparent.cgColor]
        uiBlur.layer.addSublayer(grLayer)
    }
    
    @IBAction func btnApply_Clicked(_ sender: Any) {
        
        delegate?.setSelectedCountries(countries: selected ?? [])
        self.dismiss(animated: true, completion: nil)
    }

}

extension TripFilterNationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCountryTableViewCell") as! TripCountryTableViewCell
        let name = countries[indexPath.row]
        cell.selectionStyle = .none
        cell.lblCountry.text = name
        
        if self.selected?.contains(name) == true {
            cell.lblCountry.textColor = Constants.colorBlack
            cell.imgCheck.image = UIImage(named: "ic_nation_check")
        } else {
            cell.lblCountry.textColor = Constants.colorGray
            cell.imgCheck.image = UIImage(named: "ic_nation_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selected?.append(self.countries[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! TripCountryTableViewCell
        cell.lblCountry.textColor = Constants.colorBlack
        cell.imgCheck.image = UIImage(named: "ic_nation_check")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.selected!.removeAll(where: {$0 == self.countries[indexPath.row]})
        let cell = tableView.cellForRow(at: indexPath) as! TripCountryTableViewCell
        cell.lblCountry.textColor = Constants.colorGray
        cell.imgCheck.image = UIImage(named: "ic_nation_uncheck")
    }
}
