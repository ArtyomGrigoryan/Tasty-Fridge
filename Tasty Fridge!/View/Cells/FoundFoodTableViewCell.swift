//
//  FoundFoodTableViewCell.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class FoundFoodTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameTextLabel: UILabel!
    
    static let cellIdentifier = "foundFoodCell"
    
    weak var foundFoodCellViewModel: FoodTableViewCellViewModelType? {
        willSet(foundFoodCellViewModel) {
            guard let foundFoodCellViewModel = foundFoodCellViewModel else { return }
            
            foodNameTextLabel.text = foundFoodCellViewModel.foodName.value
            foodNameTextLabel.font = setFontSize()
        }
    }
    
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
}
