//
//  TripModal.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import Parse

class Trip {
    
    var tripObjId = ""
    var city = ""
    var country = ""
    var backImgName = ""
    var userID = ""
    var dateArrive : Date?
    var dateLeave : Date?
    var isOriginalTrip = false
    
    init(){
        
    }
    
    init (withCity: String, country: String, isOriginalTrip : Bool) {        
        self.city = withCity
        self.country = country
        self.isOriginalTrip = isOriginalTrip
        
        if self.isOriginalTrip {
            self.backImgName = "bg_org_\(self.city.lowercased())"
        }
    }
    
    init (with pfObj : PFObject){
        
        self.tripObjId = pfObj.objectId ?? ""
        self.city = pfObj[DBNames.trips_city] as? String ?? ""
        self.country = pfObj[DBNames.trips_country] as? String ?? ""
        self.userID = pfObj[DBNames.trips_userObjId] as? String ?? ""
        self.dateArrive = pfObj[DBNames.trips_arrivingDate] as? Date
        self.dateLeave = pfObj[DBNames.trips_leavingDate] as? Date
        self.isOriginalTrip = pfObj[DBNames.trips_isOriginalTrip] as? Bool ?? false
        
        if self.isOriginalTrip {
            self.backImgName = "bg_org_\(self.city.lowercased())"
        }
    }
    
    func getTripBGImage() -> UIImage {
        
        if isOriginalTrip {
            return UIImage(named: "bg_org_\(city.lowercased())")! 
        } else {
            return UIImage(named: "bg_thumbnail")!
        }
    }
}
