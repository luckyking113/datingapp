//
//  LocationManager.swift
//  Chatripp
//
//  Created by developer on 2019/4/5.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class LocationManager: NSObject {
	static let sharedInstance : LocationManager = {
		let instance = LocationManager()
		return instance
	}()
	
	var locations:[Location]! = []
	
	func load(_ callback: @escaping ((_ locations:[Location]?, _ error: Any?) -> Void)) {
		if self.locations.count > 0 {
			DispatchQueue.main.async {
				callback(self.locations, nil)
			}
		}
		
		reload(callback)
	}
	
	func reload(_ callback: @escaping ((_ locations:[Location]?, _ error: Any?) -> Void)) {
		let query = PFQuery(className: Location.className)
		query.findObjectsInBackground { (results, error) in
			DispatchQueue.global(qos: .background).async {
				self.locations = []
				if error != nil {
					DispatchQueue.main.async(execute: {
						callback([], error)
					})
					return
				}
				
				for object in results! {
					do {
						let location = Location.create(object)
						let portrait = location!.portrait()
						portrait!.getDataInBackground()
						
						let landscape = location!.landscape()
						try landscape!.getData()
						
						self.locations.append(location!)
					} catch {}
				}
				
				DispatchQueue.main.async(execute: {
					callback(self.locations, nil)
				})
			}
		}
	}
}
