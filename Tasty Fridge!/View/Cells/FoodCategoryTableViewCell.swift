//
//  FoodCategoryTableViewCell.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class FoodCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var foodCategoryNameTextLabel: UILabel!
    
    static let cellIdentifier = "foodCategoryCell"
    
    weak var foodCategoryCellViewModel: FoodCategoryTableViewCellViewModelType? {
        willSet(foodCategoryCellViewModel) {
            guard let foodCategoryCellViewModel = foodCategoryCellViewModel else { return }
            
            foodCategoryNameTextLabel.text = foodCategoryCellViewModel.foodCategoryName.value
            foodCategoryNameTextLabel.font = foodCategoryCellViewModel.setFontSize()
        }
    }
}
