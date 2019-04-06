//
//  TripSelectDateVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import CVCalendar

class TripSelectDateVC: UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var viewCalendar: CVCalendarView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCalendarMonth: UILabel!
    @IBOutlet weak var viewArriving: UIView!
    @IBOutlet weak var viewLeaving: UIView!
    @IBOutlet weak var imgRectangle: UIImageView!
    
    @IBOutlet weak var imgBG: PFImageView!
    @IBOutlet weak var lblArriving: UILabel!
    @IBOutlet weak var lblLeaving: UILabel!
    
    let weekdayfont = UIFont.init(name: "SFUIText-Regular", size: 16)!
    let dayfont = UIFont.init(name: "SFUIText-Regular", size: 18)!
    
    var trip = Trip()
	var location: Location?
	
    var isArriving = true
    
    var dateArrive : Date?
    var dateLeave : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        menuView.commitMenuViewUpdate()
        viewCalendar.commitCalendarViewUpdate()

    }
    
    func setupView() {
		if self.location != nil {
			self.lblCity.text = self.location?.city()
			self.lblCountry.text = self.location?.country()
			
			self.imgBG.file = self.location?.portrait()
			self.imgBG.loadInBackground()
			
			showTriagle(isArriving: true)
		} else {
			self.lblCity.text = self.trip.city()!
			self.lblCountry.text = self.trip.country()!
			self.imgBG.image = self.trip.emptyBG()
			showTriagle(isArriving: true)
		}
    }
    
    func showTriagle(isArriving: Bool){
        self.isArriving = isArriving
        let newPoint  = CGPoint(x: isArriving ? viewArriving.center.x : viewLeaving.center.x, y: self.imgRectangle.center.y)
        
        UIView.animate(withDuration: 0.3) {
            self.imgRectangle.center = newPoint
            self.viewArriving.alpha = isArriving ? 1.0 : 0.5
            self.viewLeaving.alpha  = !isArriving ? 1.0 : 0.5
        }
    }
    
    @IBAction func clickAddTrip(_ sender: Any) {
        
        if dateArrive == nil || dateLeave == nil {            
            Helper.showAlert(target: self, title: "", message: "Please select arriving and leaving date")
            return
        }
        
        if dateArrive! < Date() || dateLeave! < Date() {
            Helper.showAlert(target: self, title: "", message: "Dates must be after today.")
            return
        }
        
        if dateArrive! > dateLeave! {
            Helper.showAlert(target: self, title: "", message: "Arriving date must be before leaving date.")
            return
        }
        
        let newTripObj = PFObject(className: DBNames.trips)
        newTripObj[DBNames.trips_userObjId] = UserManager.sharedInstance.user?.objectId
        newTripObj[DBNames.trips_arrivingDate] = self.dateArrive
        newTripObj[DBNames.trips_leavingDate] = self.dateLeave
		
		if (self.location != nil) {
			newTripObj[DBNames.trips_city] = self.location?.city()
			newTripObj[DBNames.trips_country] = self.location?.country()
			newTripObj[DBNames.trips_isOriginalTrip] = true
		} else {
			newTripObj[DBNames.trips_city] = self.trip.city
			newTripObj[DBNames.trips_country] = self.trip.country
			newTripObj[DBNames.trips_isOriginalTrip] = self.trip.isOriginal()
		}		
        
        Helper.showLoading(target: self)
        TripsManager.sharedInstance.createNewTrip(obj: newTripObj) { (success, error) in
            Helper.hideLoading(target: self)
            
            if !success {
                Helper.showAlert(target: self, title: "Failed to create new trip.", message: error?.localizedDescription ?? "Please try again.")
                
            } else {
//                self.goBackVC()
                let newTrip = Trip.create(newTripObj)
                let inviteVC = self.storyboard?.instantiateViewController(withIdentifier: "TripInviteFriendVC") as! TripInviteFriendVC
                inviteVC.trip = newTrip
                self.navigationController?.pushViewController(inviteVC, animated: true)
            }
        }
        
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.goBackVC()
    }
    
    @IBAction func clickCalendarNextMonth(_ sender: Any) {
        self.viewCalendar.loadNextView()
    }
    
    @IBAction func clickCalendarBeforeMonth(_ sender: Any) {
        self.viewCalendar.loadPreviousView()
    }
    
    @IBAction func clickType(_ sender: Any) {
        
        self.showTriagle(isArriving: (sender as! UIButton).tag == 0)
    }
    
}

extension TripSelectDateVC : CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func shouldAnimateResizing() -> Bool {
        return false
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        return true
    }
    
    func dayLabelWeekdayFont() -> UIFont {
        return self.dayfont
    }
    func dayLabelWeekdaySelectedFont() -> UIFont {
        return self.dayfont
    }
    
    func dayOfWeekFont() -> UIFont {
        return self.weekdayfont
    }

    func dayOfWeekTextColor() -> UIColor {
        return Constants.colorGray
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return Constants.colorGray
    }
    
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        
        return Constants.colorRedAC
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor.clear
    }

    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return Constants.colorGrayDark
    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }

    func presentedDateUpdated(_ date: CVDate) {
        
        self.lblCalendarMonth.text = date.globalDescription
        self.viewCalendar.contentController.refreshPresentedMonth()
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        
        if isArriving {
            self.dateArrive = dayView.date.convertedDate(calendar: Calendar.current)!
        } else {
            self.dateLeave  = dayView.date.convertedDate(calendar: Calendar.current)!
        }
        self.viewCalendar.contentController.refreshPresentedMonth()
        
        showSelectedDates()
    }
    
    func showSelectedDates() {
        self.lblArriving.text = self.dateArrive == nil ? "ARRVING" : self.dateArrive?.toString(withFormat: Constants.dateFormatDM)
        self.lblLeaving.text = self.dateLeave == nil ? "LEAVING" : self.dateLeave?.toString(withFormat: Constants.dateFormatDM)
    }
}
