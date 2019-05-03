//
//  FoodViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa
import Foundation

class FoodViewModel: FoodViewModelType {
    var foodName: BehaviorRelay<String?>
    var foodImage: BehaviorRelay<UIImage?>
    var foodQuantity: BehaviorRelay<String?>
    var foodCategory: BehaviorRelay<String?>
    var foodShelfLife: BehaviorRelay<String?>
    var foodCategoryId: BehaviorRelay<String?>
    var foodQuantityType: BehaviorRelay<String?>
    
    private var newFoodModel: Food?
    
    func saveNewFood(fridgeViewModel: FridgeCollectionViewViewModelType, foodImageData: Data) {
        CoreDataHelper.sharedInstance.saveNewFood(foodName: foodName.value!, foodQuantity: Int16(foodQuantity.value!)!,
                                                  foodQuantityType: foodQuantityType.value!,
                                                  foodShelfLife: getDateFromString(foodDate: foodShelfLife.value!),
                                                  foodImageData: foodImageData, foodCategoryId: Int16(foodCategoryId.value!)!,
                                                  fridgeViewModel: fridgeViewModel)
        
        fridgeViewModel.sectionListSubject.onNext([SectionOfFoods(header: "", items: CoreDataHelper.sharedInstance.fetchFoodsThatsInTheFridgeNow())])
    }
    
    func addFoodToFridge(fridgeViewModel: FridgeCollectionViewViewModelType) {
        CoreDataHelper.sharedInstance.addFoodToFridge(foodName: foodName.value!,
                                                      foodQuantity: Int16(foodQuantity.value!)!,
                                                      foodQuantityType: foodQuantityType.value!,
                                                      foodShelfLife: getDateFromString(foodDate: foodShelfLife.value!))
        
        fridgeViewModel.sectionListSubject.onNext([SectionOfFoods(header: "", items: CoreDataHelper.sharedInstance.fetchFoodsThatsInTheFridgeNow())])
    }
    
    func updateFood(oldFoodName: String, foodImageData: Data) {
        newFoodModel = CoreDataHelper.sharedInstance.updateFood(oldFoodName: oldFoodName,
                                                                newFoodName: foodName.value!,
                                                                foodQuantity: Int16(foodQuantity.value!)!,
                                                                foodQuantityType: foodQuantityType.value!,
                                                                foodCategoryId: Int16(foodCategoryId.value!)!,
                                                                foodShelfLife: getDateFromString(foodDate: foodShelfLife.value!),
                                                                foodImageData: foodImageData)
    }
    
    func getUpdatedFoodViewModel() -> FoodViewModel {
        return FoodViewModel(foodModel: newFoodModel!)
    }
    
    func checkEqualFoodName() -> Bool {
        let check = CoreDataHelper.sharedInstance.checkEqualFoodName(foodName: foodName.value!)
        
        return check
    }
    
    init(foodModel: Food) {
        foodName = BehaviorRelay(value: foodModel.name!)
        foodQuantityType = BehaviorRelay(value: foodModel.quantityType!)
        foodImage = BehaviorRelay(value: UIImage(data: foodModel.image!))
        foodQuantity = BehaviorRelay(value: String(describing: foodModel.quantity))
        foodCategoryId = BehaviorRelay(value: String(describing: foodModel.foodCategoryId))
        foodShelfLife = BehaviorRelay(value: getStringFromDate(foodDate: foodModel.shelfLife ?? Date()))
        foodCategory = BehaviorRelay(value: String(describing: CoreDataHelper.sharedInstance.getFoodCategoryName(foodCategoryId: foodModel.foodCategoryId)!))
    }
    
    init() {
        foodName = BehaviorRelay(value: nil)
        foodImage = BehaviorRelay(value: nil)
        foodQuantity = BehaviorRelay(value: nil)
        foodCategory = BehaviorRelay(value: nil)
        foodShelfLife = BehaviorRelay(value: nil)
        foodCategoryId = BehaviorRelay(value: nil)
        foodQuantityType = BehaviorRelay(value: nil)
    }
}
