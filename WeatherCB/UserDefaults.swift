//
//  UserDefaults.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/14.
//

import Foundation

let key_address = "key_address"

class MyAddress: NSObject, NSCoding {
    var stateName: String?
    var address: String?
    var isSelected: Bool = false
    
    init (stateName: String, address: String, isSelected: Bool) {
        self.stateName = stateName
        self.address = address
        self.isSelected = isSelected
    }

       required convenience init(coder aDecoder: NSCoder) {
           let stateName = aDecoder.decodeObject(forKey: "stateName") as? String ?? ""
           let address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
           let isSelected = aDecoder.decodeObject(forKey: "isSelected") as? Bool ?? false
           self.init(stateName: stateName, address: address, isSelected: isSelected)
       }

       func encode(with aCoder: NSCoder) {
           aCoder.encode(stateName, forKey: "stateName")
           aCoder.encode(address, forKey: "address")
           aCoder.encode(isSelected, forKey: "isSelected")
       }
}





