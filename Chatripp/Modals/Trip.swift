//
//  TripModal.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import Parse

class Trip : NSObject {
	static let className = "Trips"
	static let userId = "userObjId"
	static let arrivingDate = "arrivingDate"
	static let leavingDate = "leavingDate"
	static let city = "location_city"
	static let country = "location_country"
	static let isOriginalTrip = "isOriginalTrip"
	static let portrait = "portrait"
	static let landscape = "landscape"
	
	var object: PFObject?
	
	public static func create(_ location: Location) -> Trip {
		let trip = Trip()
		
		trip.setCity(location.city())
		trip.setCountry(location.country())
		trip.setPortrait(location.portrait()!)
		trip.setLandscape(location.landscape()!)
		trip.setIsOriginal(true)
        
		return trip
    }
    
	public static func create(_ object: PFObject) -> Trip {
		let trip = Trip()
		
		trip.object = object
		
		return trip
    }
	
	override init() {
		super.init()
		
		self.object = PFObject(className: Trip.className)
	}
	
	public func isNew() -> Bool {
		if let _ = self.objectId() {
			return false
		}
		return true
	}
	
	public func objectId() -> String? {
		return self.object?.objectId
	}
	
	public func userId() -> String? {
		return (self.object?[Trip.userId] as! String)
	}
	
	public func setUserId(_ userId: PFUser) {
		self.object?[Trip.userId] = userId
	}
	
	public func isOriginal() -> Bool! {
		return (self.object?[Trip.isOriginalTrip] as! Bool)
	}
	
	public func setIsOriginal(_ isOriginal: Bool) {
		self.object?[Trip.isOriginalTrip] = isOriginal
	}
	
	public func city() -> String? {
		return (self.object?[Trip.city] as! String)
	}
	
	public func setCity(_ city: String) {
		self.object?[Trip.city] = city
	}
	
	public func country() -> String? {
		return (self.object?[Trip.country] as! String)
	}
	
	public func setCountry(_ country: String) {
		self.object?[Trip.country] = country
	}
	
	public func arrivingDate() -> Date? {
		return (self.object?[Trip.arrivingDate] as! Date)
	}
	
	public func setArrivingDate(_ date: Date) {
		self.object?[Trip.arrivingDate] = date
	}
	
	public func leavingDate() -> Date? {
		return (self.object?[Trip.leavingDate] as! Date)
	}
	
	public func setLeavingDate(_ date: Date) {
		self.object?[Trip.leavingDate] = date
	}
	
	public func portrait() -> Any? {
		return self.object?[Trip.portrait]
	}
	
	public func setPortrait(_ file: PFFileObject) {
		self.object?[Trip.portrait] = file
	}
	
	public func landscape() -> Any? {
		return self.object?[Trip.landscape]
	}
	
	public func setLandscape(_ file: PFFileObject) {
		self.object?[Trip.landscape] = file
	}
    
    func emptyBG() -> UIImage {
		return UIImage(named: "bg_thumbnail")!
    }
}
