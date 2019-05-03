//
//  Food+CoreDataProperties.swift
//  
//
//  Created by Артем Григорян on 21/04/2019.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var shelfLife: Date?
    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var isInTheFridgeNow: Bool
    @NSManaged public var quantity: Int16
    @NSManaged public var foodCategoryId: Int16
    @NSManaged public var quantityType: String?

}
