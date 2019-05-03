//
//  Food+CoreDataClass.swift
//  
//
//  Created by Артем Григорян on 21/04/2019.
//
//

import CoreData
import Foundation
import RxDataSources

@objc(Food)
public class Food: NSManagedObject {

}

extension Food: IdentifiableType {
    public typealias Identity = String
    
    public var identity: String {
        return self.name ?? ""
    }
}

func ==(lhs: Food, rhs: Food) -> Bool {
    return lhs.name! == rhs.name!
}
