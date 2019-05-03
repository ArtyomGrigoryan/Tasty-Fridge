//
//  FoodCategoryDetailTableViewViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FoodCategoryDetailTableViewViewModelType {
    var sectionListSubject: BehaviorSubject<[SectionOfFoods]> { get }
    func customizeUI() -> CGFloat
    func getViewModelForSelectedFood() -> FoodViewModel?
    func removeFoodFromApplication(at indexPath: IndexPath)
    func checkSelectedFoodForPresenceInTheFridge(indexPath: IndexPath?) -> String?
}
