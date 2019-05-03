//
//  FridgeCollectionViewViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

class FridgeCollectionViewViewModel: FridgeCollectionViewViewModelType {
    let sectionListSubject = BehaviorSubject(value: [SectionOfFoods]())
    
    func cellViewModel(atIndexPath indexPath: IndexPath) -> FoodViewModelType? {
        guard let sections = try? sectionListSubject.value() else { return nil }
        
        var currentSection = sections[indexPath.section]
        
        let food = currentSection.items[indexPath.row]
        
        return FoodViewModel(foodModel: food)
    }
    
    func removeSelectedFoodFromFridge(forIndexPath indexPath: IndexPath) {
        guard var sections = try? sectionListSubject.value() else { return }
        
        var currentSection = sections[indexPath.section]
        
        let food = currentSection.items[indexPath.row]
        
        CoreDataHelper.sharedInstance.removeFoodFromFridge(foodName: food.name!)
        
        currentSection.items.remove(at: indexPath.row)
        
        sections[indexPath.section] = currentSection
        
        sectionListSubject.onNext(sections)
    }
    
    init() {
        sectionListSubject.onNext([SectionOfFoods(header: "", items: CoreDataHelper.sharedInstance.fetchFoodsThatsInTheFridgeNow())])
    }
}
