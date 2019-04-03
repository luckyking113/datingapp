//
//  TripInviteFriendVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/01.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class TripInviteFriendVC: UIViewController {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var imgBG: UIImageView!
    
    var trip : TripModal!
    var allUsers = [UserModal]()
    var filteredUsers = [UserModal]()
    
    var filterNations = [String]()
    var filterIsMale = true
    var filterAgeMin = 0
    var filterAgeMax = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if allUsers.count == 0 {
            self.getAllUsers()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        self.imgBG.image = trip.getTripBGImage()
        self.imgBG.addOverlay(opacity: 0.2)
        self.lblCity.text = trip.city
        self.lblCountry.text = trip.country
        self.lblStartDate.text = trip.dateArrive!.toString(withFormat: Constants.dateFormatDM)
        self.lblEndDate.text = trip.dateLeave!.toString(withFormat: Constants.dateFormatDM)
    }
    
    @IBAction func clickBack(_ sender: Any) {
//        self.goBackVC()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clickFilter(_ sender: Any) {
        
        let filterFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "TripFilterFriendVC") as! TripFilterFriendVC
        filterFriendVC.delegate = self
        filterFriendVC.countries = self.filterNations
        filterFriendVC.isMale = self.filterIsMale
        
        self.navigationController?.present(filterFriendVC, animated: true, completion: nil)
    }

    func getAllUsers() {
        
        Helper.showLoading(target: self)
        UserManager.sharedInstance.getAllUsers { (success, allUsers) in
        
            if success {
                if let users = allUsers {
                    self.allUsers = users
                    self.setFilteredUsers()
                }
            }
            
            Helper.hideLoading(target: self)
        }
    }
    func setFilteredUsers() {
        
//        self.filteredUsers = self.allUsers
        self.setNewFilter(isMale: nil, minAge: 0, maxAge: 100, nationalities: nil)
    }
}

extension TripInviteFriendVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inviteCell = tableView.dequeueReusableCell(withIdentifier: "TripInviteTableViewCell", for: indexPath) as! TripInviteTableViewCell
        
        inviteCell.setData(data: filteredUsers[indexPath.row])
        return inviteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let otherProfile = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        otherProfile.opponent = filteredUsers[indexPath.row]
        self.present(otherProfile, animated: true, completion: nil)
    }
}

extension TripInviteFriendVC : TripFilterFriendVCDelegate {
    
    func setNewFilter(isMale:Bool?, minAge: Int, maxAge: Int, nationalities:[String]?) {
        
        self.filterNations = nationalities ?? []
        self.filterIsMale = isMale ?? true
        
        self.filteredUsers = self.allUsers.filter({ (user) -> Bool in
            
            if let nations = nationalities , !nations.isEmpty {
                
                if nations.contains(where: {$0.compare(user.location.country, options: .caseInsensitive) == .orderedSame}) {
                    return true
                } else {
                    return false
                }
            }
            
            return true
        })
        
        self.mTableView.reloadData()
    }
}
