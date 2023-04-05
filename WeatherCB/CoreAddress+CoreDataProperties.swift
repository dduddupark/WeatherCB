//
//  CoreAddress+CoreDataProperties.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/04/05.
//
//

import Foundation
import CoreData


extension CoreAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreAddress> {
        return NSFetchRequest<CoreAddress>(entityName: "CoreAddress")
    }

    @NSManaged public var address: String?
    @NSManaged public var isSelected: Bool
    @NSManaged public var stateName: String?

}

extension CoreAddress : Identifiable {

}
