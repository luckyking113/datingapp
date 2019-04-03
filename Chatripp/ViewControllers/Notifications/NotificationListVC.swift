//
//  NotificationListVC.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class NotificationListVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
    }
}

extension NotificationListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "BrandonGrotesque-Bold", size: 15)!
        header.textLabel?.textColor = Constants.colorGrayDark
        header.backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return section == 0 ? "TODAY" : "YESTERDAY"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        return notificationCell
    }
}
