//
//  FoodCategoryTableViewCellViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa
import Foundation

class FoodCategoryTableViewCellViewModel: FoodCategoryTableViewCellViewModelType {
    var foodCategoryName: BehaviorRelay<String?>
    private var foodCategoryModel: FoodCategory?
    
    func setFontSize() -> UIFont? {
        let fontName = "Helvetica Neue"
        
        if DeviceType.iPhone8 {
            return UIFont(name: fontName, size: 22)
        } else if DeviceType.iPhone8Plus || DeviceType.iPhoneXs || DeviceType.iPhoneXr || DeviceType.iPhoneXsMax {
            return UIFont(name: fontName, size: 24)
        } else {
            return UIFont(name: fontName, size: 20)
        }
    }
    
    init(foodCategoryModel: FoodCategory) {
        self.foodCategoryModel = foodCategoryModel
        self.foodCategoryName = BehaviorRelay(value: self.foodCategoryModel?.name!)
    }
}
