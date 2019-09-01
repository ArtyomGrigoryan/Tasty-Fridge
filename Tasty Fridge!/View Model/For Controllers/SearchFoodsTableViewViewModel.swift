//
//  SearchFoodsTableViewViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

class SearchFoodsTableViewViewModel: SearchFoodsTableViewViewModelType {
    var foods: [Food]
    var shownFoods: BehaviorSubject<[Food]>
    private var selectedIndexPath: IndexPath?
    
    func foodViewModelForSelectedRow() -> FoodViewModelType? {
        guard let selectedIndexPath = selectedIndexPath, let food = getFood(atIndexPath: selectedIndexPath) else { return nil }
        return FoodViewModel(foodModel: food)
    }
    
    func cellViewModel(forRow row: String) -> FoodTableViewCellViewModelType? {
        let selectedFood = foods.first { $0.name == row }
        guard let food = selectedFood else { return nil }
        return FoodTableViewCellViewModel(foodModel: food)
    }
    
    func checkSelectedFoodForPresenceInTheFridge(atIndexPath indexPath: IndexPath) -> String? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        
        if let food = getFood(atIndexPath: selectedIndexPath) {
            if food.isInTheFridgeNow {
                return food.name
            }
        }
        
        return nil
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        selectedIndexPath = indexPath
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
    
    private func getFood(atIndexPath indexPath: IndexPath) -> Food? {
        guard let foods = try? shownFoods.value() else { return nil }
        let food = foods[indexPath.row]
        return food
    }
    
    init() {
        shownFoods = BehaviorSubject<[Food]>(value: [])
        foods = CoreDataHelper.sharedInstance.fetchAllFoods()
    }
}
