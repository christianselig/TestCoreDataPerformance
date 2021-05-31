//
//  IceCream+CoreDataProperties.swift
//  TestCoreData
//
//  Created by Christian Selig on 2021-05-31.
//
//

import Foundation
import CoreData

extension IceCream {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<IceCream> {
        return NSFetchRequest<IceCream>(entityName: "IceCream")
    }

    @NSManaged public var name: String
    @NSManaged public var subscribers: Int64

}

extension IceCream : Identifiable {

}
