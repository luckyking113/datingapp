//
//  UITableView.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/08.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func sizeHeaderToFit(){
        
        guard let headerView = self.tableHeaderView else {
            return
        }
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
    }
    
    func sizeFooterToFit(){
        
        guard let footerView = self.tableFooterView else {
            return
        }
        
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = footerView.frame
        frame.size.height = height
        footerView.frame = frame
        
        self.tableFooterView = footerView
    }
    
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
}
