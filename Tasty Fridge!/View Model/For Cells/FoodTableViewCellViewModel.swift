//
//  FoodTableViewCellViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa

class FoodTableViewCellViewModel: FoodTableViewCellViewModelType {
    var foodName: BehaviorRelay<String?>
    private var foodModel: Food?
    
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
    
    init(foodModel: Food) {
        self.foodModel = foodModel
        self.foodName = BehaviorRelay(value: foodModel.name!)
    }
}
