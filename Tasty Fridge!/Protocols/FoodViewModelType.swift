//
//  FoodViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa

protocol FoodViewModelType: class {
    var foodName: BehaviorRelay<String?> { get }
    var foodImage: BehaviorRelay<UIImage?> { get }
    var foodQuantity: BehaviorRelay<String?> { get }
    var foodCategory: BehaviorRelay<String?> { get }
    var foodShelfLife: BehaviorRelay<String?> { get }
    var foodCategoryId: BehaviorRelay<String?> { get }
    var foodQuantityType: BehaviorRelay<String?> { get }
    
    func checkEqualFoodName() -> Bool
    func getUpdatedFoodViewModel() -> FoodViewModel
    func updateFood(oldFoodName: String, foodImageData: Data)
    func addFoodToFridge(fridgeViewModel: FridgeCollectionViewViewModelType)
    func saveNewFood(fridgeViewModel: FridgeCollectionViewViewModelType, foodImageData: Data)
}
