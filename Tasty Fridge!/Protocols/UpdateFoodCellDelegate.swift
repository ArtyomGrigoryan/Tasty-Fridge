//
//  UpdateFoodCellDelegate.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol UpdateFoodCellDelegate {
    func updateFoodCell(foodShelfLife: Date, foodName: String?, foodImageData: Data?, foodQuantity: String?, foodQuantityType: String?)
}
