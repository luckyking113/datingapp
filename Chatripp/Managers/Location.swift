//
//  Location.swift
//  Chatripp
//
//  Created by developer on 2019/4/6.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class Location: NSObject {
	static let className = "Locations"
	static let country = "country"
	static let city = "city"
	static let portrait = "portrait"
	static let landscape = "landscape"
	
	public var object: PFObject!
	
	static func create(_ object: PFObject!) -> Location! {
		let location = Location()
		location.object = object
		return location
	}
	
	override init() {
		super.init()
	}
	
	func objectId() -> String! {
		return self.object.objectId!
	}
	
	func city() -> String! {
		return (self.object![Location.city] as! String)
	}
	
	func setCity(_ city: String!) {
		self.object[Location.city] = city
	}
	
	func country() -> String! {
		return (self.object![Location.country] as! String)
	}
	
	func setCountry(_ country: String!) {
		self.object[Location.country] = country
	}
	
	func portrait() -> PFFileObject? {
		return self.object![Location.portrait] as? PFFileObject
	}
	
	func landscape() -> PFFileObject? {
		return self.object![Location.landscape] as? PFFileObject
	}
}
