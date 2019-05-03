//
//  SearchFoodsTableViewViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift

protocol SearchFoodsTableViewViewModelType {
    var foods: [Food] { get }
    var shownFoods: BehaviorSubject<[Food]> { get }
    func customizeUI() -> CGFloat
    func selectRow(atIndexPath indexPath: IndexPath)
    func foodViewModelForSelectedRow() -> FoodViewModelType?
    func cellViewModel(forRow row: String) -> FoodTableViewCellViewModelType?
    func checkSelectedFoodForPresenceInTheFridge(atIndexPath indexPath: IndexPath) -> String?
}
