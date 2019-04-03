//
//  Date.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/27.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(withFormat : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: self)
    }
}
