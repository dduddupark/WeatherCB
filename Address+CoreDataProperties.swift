//
//  Address+CoreDataProperties.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/04/04.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "CoreAddress")
    }

    @NSManaged public var address: String?
    @NSManaged public var isSelected: Bool
    @NSManaged public var stateName: String?

}

extension Address : Identifiable {

}
