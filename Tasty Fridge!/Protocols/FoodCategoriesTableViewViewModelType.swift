//
//  FoodCategoriesTableViewViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa

protocol FoodCategoriesTableViewViewModelType {
    var foodCategories: BehaviorRelay<[FoodCategory]> { get }
    func customizeUI() -> CGFloat
    func selectRow(atIndexPath indexPath: IndexPath)
    func cellViewModel(forRow row: Int) -> FoodCategoryTableViewCellViewModelType?
    func getFoodCategoryDetailViewModelForSelectedRow() -> FoodCategoryDetailTableViewViewModelType?
}
