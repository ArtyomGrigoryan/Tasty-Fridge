//
//  FoodCategory+CoreDataProperties.swift
//  
//
//  Created by Артем Григорян on 21/04/2019.
//
//

import Foundation
import CoreData


extension FoodCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodCategory> {
        return NSFetchRequest<FoodCategory>(entityName: "FoodCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16

}
