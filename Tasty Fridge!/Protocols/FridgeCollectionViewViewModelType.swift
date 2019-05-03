//
//  FridgeCollectionViewViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift

protocol FridgeCollectionViewViewModelType {
    var sectionListSubject: BehaviorSubject<[SectionOfFoods]> { get }
    func removeSelectedFoodFromFridge(forIndexPath indexPath: IndexPath)
    func cellViewModel(atIndexPath indexPath: IndexPath) -> FoodViewModelType?
}
