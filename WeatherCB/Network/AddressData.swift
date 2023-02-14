//
//  AddressData.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/11.
//

import Foundation

struct AddressData: Codable {
    let response: AddressResponse?
}

struct AddressResponse: Codable {
    let header: Header?
    let body: AddressBody?
}

struct Header: Codable {
    let resultCode: String?
    let resultMsg: String?
}

struct AddressBody: Codable {
    let totalCount: Int?
    let items: [Address]?
}

struct Address: Codable {
    let stationName: String?
}
