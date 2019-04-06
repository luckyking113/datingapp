//
//  ProfileEditVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces

class ProfileEditVC: UIViewController {

    @IBOutlet weak var imgAvatar: PFImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
	@IBOutlet weak var txtBirthday: UITextField!
	@IBOutlet weak var txtNationality: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var imgCoverPhoto: PFImageView!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    var isOpenAvatar = true
	
	var city = ""
	var country = ""
	var address = ""
	var lat = ""
	var lon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadData() {
        
        self.imgAvatar.image = Helper.thumbnailImage()
        self.imgCoverPhoto.image = Helper.thumbnailImage()
        
        if let profile = UserManager.sharedInstance.profile {
            
            if let avatar = profile.avatar() as? PFFileObject {
                self.imgAvatar.file = avatar
                self.imgAvatar.loadInBackground()
            }
            
            if let cover = profile.cover() as? PFFileObject {
                self.imgCoverPhoto.file = cover
                self.imgCoverPhoto.loadInBackground()
            }
            
			self.txtFirstName.text = profile.firstName()
			self.txtLastname.text = profile.lastName()
			self.txtBirthday.text = profile.birthday()
			self.txtNationality.text = profile.nationality()
			self.txtBio.text = profile.bio()
			let location_city = profile.city() ?? ""
			let location_country = profile.country() ?? ""
            
            if !location_city.isEmpty && !location_country.isEmpty {
                self.btnCity.setTitle("\(location_city) , \(location_country)", for: .normal)
            } else {
                self.btnCity.setTitle("", for: .normal)
            }
            self.txtEmail.text = UserManager.sharedInstance.user?.email ?? ""
        }

    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.goBackVC()
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if let profile = UserManager.sharedInstance.profile {
            
			profile.setFirstName(txtFirstName.text!)
			profile.setLastName(txtLastname.text!)
			profile.setBirthday(txtBirthday.text!)
			profile.setNationality(txtNationality.text!)
            profile.setBio(txtBio.text)
            
            // Address
            profile.setCity(self.city)
            profile.setCountry(self.country)
            profile.setAddress(self.address)
            profile.setLat(self.lat)
            profile.setLon(self.lon)
            
            if let avatar = imgAvatar.image {
				profile.setAvatar(avatar)
            }
            
            if let coverPhoto = imgCoverPhoto.image {
				profile.setCover(coverPhoto)
            }
            UserManager.sharedInstance.profile = profile
            
            Helper.showLoading(target: self)
            UserManager.sharedInstance.saveProfile { (success, error) in
                Helper.hideLoading(target: self)
                
                if !success {
                    Helper.showAlert(target: self, title: "Update profile failed", message: error?.localizedDescription ?? "Please try again.")
                } else {
                    Helper.showAlert(target: self, title: "Success", message: "Profile edited successfully.")
                }
            }
            
        }
    }
    
    @IBAction func clickEditAvatar(_ sender: UIButton) {
        isOpenAvatar = true
        openPickerView()
    }
    
    @IBAction func clickEditCover(_ sender: Any) {
        isOpenAvatar = false
        openPickerView()
    }
    
    @IBAction func clickCityInput(_ sender: UIButton) {
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        self.present(placePickerController, animated: true, completion: nil)
    }
    
    func openPickerView() {
        
        let optionMenu = UIAlertController(title: "", message: "Take Photo", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "From Library", style: .default) { (_ UIAlertAction) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            optionMenu.addAction(libraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "From Camera", style: .default) { (_ UIAlertAction) in
                let camera = UIImagePickerController()
                camera.sourceType  = .camera
                camera.allowsEditing = true
                camera.cameraCaptureMode = .photo
                camera.modalPresentationStyle = .fullScreen
                camera.delegate = self
                self.present(camera, animated: true, completion: nil)
            }
            optionMenu.addAction(cameraAction)
        }
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        if isOpenAvatar {
            self.imgAvatar.image = photo
        } else {
            self.imgCoverPhoto.image = photo
        }
    }
    
}

extension ProfileEditVC : GMSAutocompleteViewControllerDelegate , UITextFieldDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
//        print("Place attributions: \(place.attributions)")
        
		self.city = place.addressComponents?.first(where: { $0.type == "locality" })?.name ?? ""
		self.country = place.addressComponents?.first(where: { $0.type == "country" })?.name ?? ""
		self.address = place.formattedAddress ?? "'"
		self.lat = String(place.coordinate.latitude)
		self.lon = String(place.coordinate.longitude)
		
        self.btnCity.setTitle(place.formattedAddress, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
