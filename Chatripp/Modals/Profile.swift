//
//  UserModal.swift
//  Chatripp
//
//  Created by Famousming on 2019/03/20.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import GooglePlaces
import Parse

class Profile {
	static let className = "Profile"
	static let userId = "userObjId"
	static let firstName = "first_name"
	static let lastName = "last_name"
	static let city = "city"
	static let country = "country"
	static let bio = "bio"
	static let lat = "latitude"
	static let lon = "longitude"
	static let address = "formatted_address"
	static let isPrivate = "setting_private"
	static let isRestrictFollow = "restrict_follow"
	static let avatar = "avatar"
	static let cover = "cover_photo"
	static let birthday = "birthday"
	static let nationality = "nationality"
	
	var object: PFObject!
	
    public static func create() -> Profile {
		let profile = Profile()
		
		profile.setUserId(PFUser.current()!)
		profile.setFirstName("")
		profile.setLastName("")
		profile.setBio("")
		profile.setCity("")
		profile.setCountry("")
		profile.setAddress("")
		profile.setIsPrivate(false)
		profile.setIsRestrictFollow(false)
		
		return profile
    }
	
	public static func create(_ object: PFObject) -> Profile {
		let profile = Profile()
		profile.object = object
		return profile
	}
	
	init() {
		self.object = PFObject(className: Profile.className)
	}
	
	func objectId() -> String? {
		return self.object.objectId
	}
	
	public func userId() -> String? {
		return (self.object?[Profile.userId] as! String)
	}
	
	public func setUserId(_ user: PFUser) {
		self.object?[Profile.userId] = user.objectId
	}
	
	public func firstName() -> String? {
		return self.object?[Profile.firstName] as? String ?? ""
	}
	
	public func setFirstName(_ firstName: String) {
		self.object?[Profile.lastName] = firstName
	}
	
	public func lastName() -> String? {
		return self.object?[Profile.lastName] as? String ?? ""
	}
	
	public func setLastName(_ lastName: String) {
		self.object?[Profile.lastName] = lastName
	}
	
	public func fullName() -> String {
		let firstName = self.firstName()
		let lastName = self.lastName()
		return "\(firstName ?? "") \(lastName ?? "")"
	}
	
	public func city() -> String? {
		return self.object?[Profile.city] as? String
	}
	
	public func setCity(_ city: String) {
		self.object?[Profile.city] = city
	}
	
	public func country() -> String? {
		return self.object?[Profile.country] as? String
	}
	
	public func setCountry(_ country: String) {
		self.object?[Profile.country] = country
	}
	
	public func bio() -> String? {
		return self.object?[Profile.bio] as? String ?? ""
	}
	
	public func setBio(_ bio: String) {
		self.object?[Profile.bio] = bio
	}
	
	public func lat() -> String? {
		return self.object?[Profile.lat] as? String
	}
	
	public func setLat(_ lat: String) {
		self.object?[Profile.lat] = lat
	}
	
	public func lon() -> String? {
		return self.object?[Profile.lon] as? String
	}
	
	public func setLon(_ lon: String) {
		self.object?[Profile.lat] = lon
	}
	
	public func address() -> String? {
		return self.object?[Profile.address] as? String
	}
	
	public func setAddress(_ address: String) {
		self.object?[Profile.address] = address
	}
	
	public func isPrivate() -> Bool? {
		return self.object?[Profile.isPrivate] as? Bool
	}
	
	public func setIsPrivate(_ isPrivate: Bool) {
		self.object?[Profile.isPrivate] = isPrivate
	}
	
	public func isRestrictFollow() -> Bool? {
		return self.object?[Profile.isRestrictFollow] as? Bool
	}
	
	public func setIsRestrictFollow(_ isRestrictFollow: Bool) {
		self.object?[Profile.isRestrictFollow] = isRestrictFollow
	}
	
	public func cover() -> Any? {
		return self.object?[Profile.cover]
	}
	
	public func setCover(_ cover: PFFileObject) {
		self.object?[Profile.cover] = cover
	}
	
	public func setCover(_ image: UIImage) {
		let file = PFFileObject(name: "cover.png", data: image.pngData()!)
		self.object?[Profile.cover] = file
	}
	
	public func avatar() -> Any? {
		return self.object?[Profile.avatar]
	}
	
	public func setAvatar(_ avatar: PFFileObject) {
		self.object?[Profile.avatar] = avatar
	}
	
	public func setAvatar(_ image: UIImage) {
		let file = PFFileObject(name: "avatar.png", data: image.pngData()!)
		self.object?[Profile.cover] = file
	}
	
	public func birthday() -> String {
		return self.object?[Profile.birthday] as? String ?? ""
	}
	
	public func setBirthday(_ birthday: String) {
		self.object?[Profile.birthday] = birthday
	}
	
	public func nationality() -> String {
		return self.object?[Profile.nationality] as? String ?? ""
	}
	
	public func setNationality(_ nationality: String) {
		self.object?[Profile.nationality] = nationality
	}
	
	public func save(callback: @escaping ((_ error: Any?) -> Void)) {
		self.object.saveInBackground { (success, error) in
			DispatchQueue.main.async(execute: {
				callback(error)
			})
		}
	}
	
	public func saveInBackground() {
		self.object.saveInBackground()
	}
}
