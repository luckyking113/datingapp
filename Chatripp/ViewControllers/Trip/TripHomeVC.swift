//
//  TripHomeVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import GooglePlaces
import Parse

class TripHomeVC: UIViewController {

    @IBOutlet weak var viewNewTrip: UIView!

    @IBOutlet weak var viewUpcoming: UIView!

    @IBOutlet weak var txtWhereTo: UITextField!
    @IBOutlet weak var viewFocus: UIView!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnWhereTo: UIButton!
    
    var isNewTrip = true
    
    var trips = [Trip]()
	var locations = [Location]()
	var filteredLocation = [Location]()
    
    var upcomingTrips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initDefaultData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        initMyTrips()
    }
    
    func setupView() {
        
        self.showTripType(type: true)
        self.txtWhereTo.setPlaceHolderColor(with: Constants.colorBlack)
        
        self.mTableView.register(UINib(nibName: "TableCellNoData", bundle: nil), forCellReuseIdentifier: "TableCellNoData")
        
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
    }
    
    func initDefaultData() {
		Helper.showLoading(target: self)
		LocationManager.sharedInstance.load { (results, error) in
			self.locations = results!
			self.filteredLocation = results!
			
			self.mTableView.reloadData()
			
			Helper.hideLoading(target: self)
		}
    }
    
    func initMyTrips() {
        self.upcomingTrips = TripsManager.sharedInstance.myTrips
        if !self.isNewTrip {
            self.mTableView.reloadData()
        }
    }
    
    func showTripType(type : Bool){
        
        self.isNewTrip = type
        self.viewNewTrip.alpha = type ? 1.0 : 0.5
        self.viewUpcoming.alpha = type ? 0.5 : 1.0
        
        self.searchView.isHidden = !isNewTrip
        self.searchBarHeightConstraint.constant = isNewTrip ? 70 : 0
        self.mTableView.reloadData {
            self.mTableView.setContentOffset(.zero, animated: true)
        }
        
    }
    
    @IBAction func clickType(_ sender: UIButton) {
        
        self.upcomingTrips = TripsManager.sharedInstance.myTrips
        self.showTripType(type: sender.tag == 0)
        
        let newPoint  = CGPoint(x: sender.tag == 0 ? viewNewTrip.center.x : viewUpcoming.center.x, y: self.viewFocus.center.y)
        
        UIView.animate(withDuration: 0.3) {
            self.viewFocus.center = newPoint
        }
    }
    
    @IBAction func clickWhereTo(_ sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        self.present(placePickerController, animated: true, completion: nil)
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        
        self.filteredLocation = self.locations.filter({ (location) -> Bool in
            let city = location.city()
			let country = location.country()
			if sender.text == "" || city!.lowercased().range(of: sender.text!) != nil || country!.lowercased().range(of: sender.text!) != nil {
                return true
            }
            return false
        })
        
        self.mTableView.reloadData()
    }
}

extension TripHomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.isNewTrip ? self.filteredLocation.count : self.upcomingTrips.count
        
        return count > 0 ? count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let count = self.isNewTrip ? self.filteredLocation.count : self.upcomingTrips.count
        
        return count > 0 ? 200 : 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = self.isNewTrip ? self.filteredLocation.count : self.upcomingTrips.count
        if count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripHomeTableViewCell", for: indexPath) as! TripHomeTableViewCell
			cell.setTrip(self.isNewTrip ? Trip.create(self.filteredLocation[indexPath.row]) : self.upcomingTrips[indexPath.row])			
            return cell
        } else {
            let noTripCell = tableView.dequeueReusableCell(withIdentifier: "TableCellNoData", for: indexPath) as! TableCellNoData
            noTripCell.imgIcon.image = UIImage(named: "ic_noupcoming_trips")
            noTripCell.lblTitle.text = "no_trips_coming".localized
            noTripCell.lblContent.text = "no_trips_coming_content".localized
            
//            emptyCell.lblContent.text = "no_trips_coming".localized
            return noTripCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = self.isNewTrip ? self.filteredLocation.count : self.upcomingTrips.count
        if count > 0 {
            if isNewTrip {
				if self.isNewTrip {
					self.moveToAddDateVC(self.filteredLocation[indexPath.row])
				} else {
					self.moveToAddDateVC(trip: self.upcomingTrips[indexPath.row])
				}
            } else {
                // upcomingTrip
                let inviteVC = self.storyboard?.instantiateViewController(withIdentifier: "TripInviteFriendVC") as! TripInviteFriendVC
                inviteVC.trip = self.upcomingTrips[indexPath.row]
                self.navigationController?.pushViewController(inviteVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isNewTrip || (!isNewTrip && self.upcomingTrips.count == 0)  {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        if isNewTrip || (!isNewTrip && self.upcomingTrips.count == 0)  {
            return nil
        } else {

            let deleteAction = UITableViewRowAction(style: .default, title: "") { (action, indexPath) in

                Helper.showLoading(target: self)
                TripsManager.sharedInstance.deleteTrip(trip: self.upcomingTrips[indexPath.row], completion: { (success, error) in
                    Helper.hideLoading(target: self)
                    
                    if success {
                        self.initMyTrips()
                    } else {
                        Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
                    }
                })
            }
            deleteAction.backgroundColor = Constants.colorRedLight

            return [deleteAction]
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if isNewTrip || (!isNewTrip && self.upcomingTrips.count == 0)  {
            return nil
        } else {
            let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                // Call edit action
                
                Helper.showLoading(target: self)
                TripsManager.sharedInstance.deleteTrip(trip: self.upcomingTrips[indexPath.row], completion: { (success, error) in
                    Helper.hideLoading(target: self)
                    
                    if success {
                        self.initMyTrips()
                    } else {
                        Helper.showAlert(target: self, title: "", message: error?.localizedDescription ?? "Please try again")
                    }
                })
                
                // Reset state
                success(true)
            })
            deleteAction.image = UIImage(named: "ic_delete")
            deleteAction.backgroundColor = Constants.colorRedLight
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    func moveToAddDateVC(trip : Trip) {
        
        let addTripVC = self.storyboard?.instantiateViewController(withIdentifier: "TripSelectDateVC") as! TripSelectDateVC
        addTripVC.trip = trip
        self.navigationController?.pushViewController(addTripVC, animated: true)
    }
	
	func moveToAddDateVC(_ location : Location) {
		let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TripSelectDateVC") as! TripSelectDateVC
		viewController.location = location
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}

extension TripHomeVC : GMSAutocompleteViewControllerDelegate , UITextFieldDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
//        print("Place attributions: \(place.attributions)")
        
		let city = place.addressComponents?.first(where: { $0.type == "locality" })?.name ?? ""
		let country = place.addressComponents?.first(where: { $0.type == "country" })?.name ?? ""
		
		let trip = Trip()
		trip.setCity(city)
		trip.setCountry(country)
		trip.setIsOriginal(false)
        self.moveToAddDateVC(trip: trip)

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
