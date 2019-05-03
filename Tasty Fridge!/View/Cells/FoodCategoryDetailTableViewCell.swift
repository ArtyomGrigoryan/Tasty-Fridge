//
//  FoodCategoryDetailTableViewCell.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class FoodCategoryDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameTextLabel: UILabel!
    
    static let cellIdentifier = "foodCategoryDetailCell"
    
    var foodCategoryDetailCellViewModel: FoodTableViewCellViewModelType? {
        willSet(foodCategoryDetailCellViewModel) {
            guard let foodCategoryDetailCellViewModel = foodCategoryDetailCellViewModel else { return }
            
            foodNameTextLabel.text = foodCategoryDetailCellViewModel.foodName.value
            foodNameTextLabel.font = foodCategoryDetailCellViewModel.setFontSize()
        }
    }
}
