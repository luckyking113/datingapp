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
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var imgCoverPhoto: PFImageView!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    var isOpenAvatar = true
    var locationModal = LocationModal()
    
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
            
            if let avatar = profile[DBNames.profile_avatar] as? PFFileObject {
                self.imgAvatar.file = avatar
                self.imgAvatar.loadInBackground()
            }
            
            if let cover = profile[DBNames.profile_coverphoto] as? PFFileObject {
                self.imgCoverPhoto.file = cover
                self.imgCoverPhoto.loadInBackground()
            }
            
            self.txtFirstName.text = profile[DBNames.profile_firstname] as? String ?? ""
            self.txtLastname.text = profile[DBNames.profile_lastname] as? String ?? ""
            self.txtBio.text = profile[DBNames.profile_bio] as? String ?? ""
            let location_city = profile[DBNames.profile_city] as? String ?? ""
            let location_country = profile[DBNames.profile_country] as? String ?? ""
            
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
            
            profile[DBNames.profile_firstname] = txtFirstName.text
            profile[DBNames.profile_lastname] = txtLastname.text
            profile[DBNames.profile_bio] = txtBio.text
            profile[DBNames.profile_city] = self.btnCity.titleLabel?.text
            
            // Address
            profile[DBNames.profile_city] = self.locationModal.city
            profile[DBNames.profile_country] = self.locationModal.country
            profile[DBNames.profile_formatted_address] = self.locationModal.formattedAddress
            profile[DBNames.profile_latitude] = self.locationModal.lat
            profile[DBNames.profile_longitude] = self.locationModal.lon
            
            if let avatar = imgAvatar.image {
                if let data = avatar.pngData(){
                    let file = PFFileObject(name: "avatar", data: data)
                    profile[DBNames.profile_avatar] = file
                }
            }
            
            if let coverPhoto = imgCoverPhoto.image {
                if let data = coverPhoto.pngData(){
                    let file = PFFileObject(name: "coverPhoto", data: data)
                    profile[DBNames.profile_coverphoto] = file
                }
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
        
        locationModal = LocationModal(withPlace: place)
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
