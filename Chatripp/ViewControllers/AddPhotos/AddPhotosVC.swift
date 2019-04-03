//
//  AddPhotosVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/08.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces

protocol AddPhotosVCDelegate {
    
    func setImage(img: UIImage)
    func setPhotoSet(obj: PFObject)
}

class AddPhotosVC: UIViewController {

    @IBOutlet weak var imgPhoto: PFImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewSelectDate: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblPhotoSet: UILabel!
    
//    var isFirstLoad = true
    var selectedDate = Date()
    var location = ""
    var selectedPhotoSet : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        if isFirstLoad {
//            self.openPickerView()
//            isFirstLoad = false
//        }
//    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setupView() {
        lblTitle.text = "title_post_photo".localized
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickDate))
        self.lblDate.addGestureRecognizer(tapGesture)
        self.viewSelectDate.isHidden = true
        
        let tapGestureImg = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        self.imgPhoto.isUserInteractionEnabled = true
        self.imgPhoto.addGestureRecognizer(tapGestureImg)
        showDate()
    }
    
    @IBAction func clickBack(_ sender: Any) {
//        self.goBackVC()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clickPost(_ sender: Any) {
        
        if let imgData = self.imgPhoto.image?.pngData() {
            
            if location.isEmpty {
                Helper.showAlert(target: self, title: "", message: "Please input City.")
                return
            }
            
            if selectedPhotoSet == nil {
                Helper.showAlert(target: self, title: "", message: "Please choose a photo set.")
                return
            }
            print(selectedPhotoSet?.objectId)
            let obj = PFObject(className: DBNames.posts)
            obj[DBNames.posts_userObjId] = UserManager.sharedInstance.user?.objectId
            obj[DBNames.posts_location] = location
            obj[DBNames.posts_date] = self.selectedDate
            obj[DBNames.posts_photo] = PFFileObject(name: "mypost", data: imgData)
            obj[DBNames.posts_photoSetId] = selectedPhotoSet?.objectId
            
            Helper.showLoading(target: self)
            PostsManager.sharedInstance.createNewPost(obj: obj) { (success, error) in
                
                Helper.hideLoading(target: self)
                if !success {
                    Helper.showAlert(target: self, title: "Posting photo failed", message: error?.localizedDescription ?? "Please try again.")
                } else {
                    self.goBackVC()
                }
            }
        } else {
             Helper.showAlert(target: self, title: "", message: "Please select your photo")
        }
    }
    
    @objc func clickDate() {
        self.datePicker.date = selectedDate
        self.viewSelectDate.isHidden = false
    }
    @objc func clickImage() {
//        self.openPickerView()
        let getPhotosVC = self.storyboard?.instantiateViewController(withIdentifier: "GetPhotosVC") as! GetPhotosVC
        getPhotosVC.addPhotoDelegate = self
        self.navigationController?.pushViewController(getPhotosVC, animated: true)
    
    }
    
    @IBAction func clickSelectedDate(_ sender: UIButton) {
        self.viewSelectDate.isHidden = true
        self.selectedDate = self.datePicker.date
        self.showDate()
    }
   
    @IBAction func clickPhotoSet(_ sender: Any) {
        
        let choosePhotoSetVC = self.storyboard?.instantiateViewController(withIdentifier: "ChoosePhotosetVC") as! ChoosePhotosetVC
        choosePhotoSetVC.addPhotoVCdelegate = self
        self.navigationController?.pushViewController(choosePhotoSetVC, animated: true)
    }
    
    @IBAction func cityChanged(_ sender: UITextField) {

    }
    
    func showDate() {

        self.lblDate.text = self.selectedDate.toString(withFormat: Constants.dateFormatPost)
    }
    
    @IBAction func clickLocation(_ sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        self.present(placePickerController, animated: true, completion: nil)
    }
}

extension AddPhotosVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        self.imgPhoto.image = photo
    }
    
}

extension AddPhotosVC : GMSAutocompleteViewControllerDelegate , UITextFieldDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        //        print("Place attributions: \(place.attributions)")
        
        self.btnLocation.setTitle(place.formattedAddress, for: .normal)
        self.location = place.formattedAddress ?? ""
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

extension AddPhotosVC : AddPhotosVCDelegate {
    
    func setPhotoSet(obj: PFObject) {
        
        selectedPhotoSet = obj
        self.lblPhotoSet.text = obj[DBNames.photoSets_setname] as? String ?? ""
    }
        
    func setImage(img: UIImage) {
        
        self.imgPhoto.image = img
    }
}
