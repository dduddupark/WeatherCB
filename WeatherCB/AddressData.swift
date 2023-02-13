//
//  AddressData.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/11.
//

import Foundation

struct AddressData: Codable {
    let response: Response?
 
}

struct Response: Codable {
    //let header: Header?
    let body: Body?
    
}

struct Header: Codable {
    let resultCode: String?
    let resultMsg: String?
    
}

struct Body: Codable {
    let totalCount: Int?
    let items: [Address]?

}

struct Address: Codable {
    let stationName: String?
    
}
