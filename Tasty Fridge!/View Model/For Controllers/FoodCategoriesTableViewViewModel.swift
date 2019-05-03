//
//  FoodCategoriesTableViewViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa
import Foundation

class FoodCategoriesTableViewViewModel: FoodCategoriesTableViewViewModelType {
    private var selectedIndexPath: Int?
    var foodCategories: BehaviorRelay<[FoodCategory]>
    
    func cellViewModel(forRow row: Int) -> FoodCategoryTableViewCellViewModelType? {
        let foodCategory = foodCategories.value[row]
        
        return FoodCategoryTableViewCellViewModel(foodCategoryModel: foodCategory)
    }
    
    func getFoodCategoryDetailViewModelForSelectedRow() -> FoodCategoryDetailTableViewViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        
        let foodCategoryId = foodCategories.value[selectedIndexPath]
        
        return FoodCategoryDetailTableViewViewModel(foodCategoryId: foodCategoryId.id)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath.row
    }
    
    func customizeUI() -> CGFloat {
        if DeviceType.iPhone8 {
            return CGFloat(50)
        } else if DeviceType.iPhone8Plus || DeviceType.iPhoneXs || DeviceType.iPhoneXr || DeviceType.iPhoneXsMax {
            return CGFloat(56)
        } else {
            return CGFloat(44)
        }
    }
    
    init() {
        foodCategories = BehaviorRelay(value: CoreDataHelper.sharedInstance.fetchFoodCategories())
    }
}
