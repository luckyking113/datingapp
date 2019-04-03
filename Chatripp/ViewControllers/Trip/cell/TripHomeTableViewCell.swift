//
//  TripHomeTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class TripHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var lblDateLeave: UILabel!
    @IBOutlet weak var lblDateArrive: UILabel!
    
    var trip : TripModal!
    var isNewTrip = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgCity.addOverlay(opacity: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTrip(celltrip : TripModal, newTrip: Bool) {
        
        self.isNewTrip = newTrip
        self.trip = celltrip
        self.imgCity.image = trip.getTripBGImage()
        self.lblCity.text = trip.city
        self.lblCountry.text = trip.country
        self.viewSchedule.isHidden = isNewTrip
        
        if !isNewTrip {
            self.lblDateLeave.text = self.trip.dateLeave?.toString(withFormat: Constants.dateFormatDM)
            self.lblDateArrive.text = self.trip.dateArrive?.toString(withFormat: Constants.dateFormatDM)
        }
    }

}
