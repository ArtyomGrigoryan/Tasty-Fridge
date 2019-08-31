//
//  FoodCategoryDetailTableViewViewModel.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift
import RxCocoa

class FoodCategoryDetailTableViewViewModel: FoodCategoryDetailTableViewViewModelType {
    let sectionListSubject = BehaviorSubject(value: [SectionOfFoods]())
    private var selectedIndexPath: IndexPath?
    private let foodCategoryId: Int16
    
    func checkSelectedFoodForPresenceInTheFridge(indexPath: IndexPath?) -> String? {
        guard
            let sections = try? sectionListSubject.value(),
            let indexPath = indexPath
        else { return nil }
        
        selectedIndexPath = indexPath
        
        let currentSection = sections[indexPath.section]
        let food = currentSection.items[indexPath.row]
        
        if food.isInTheFridgeNow {
            return food.name
        }
        
        return nil
    }
    
    func removeFoodFromApplication(at indexPath: IndexPath) {
        guard var sections = try? sectionListSubject.value() else { return }
        
        var currentSection = sections[indexPath.section]
  
        let food = currentSection.items[indexPath.row]
        
        CoreDataHelper.sharedInstance.removeFoodFromApplication(foodName: food.name!)
        
        currentSection.items.remove(at: indexPath.row)
        
        sections[indexPath.section] = currentSection

        sectionListSubject.onNext(sections)
    }
    
    func getViewModelForSelectedFood() -> FoodViewModel? {
        guard
            let selectedIndexPath = selectedIndexPath,
            let sections = try? sectionListSubject.value()
        else { return nil }
        let currentSection = sections[selectedIndexPath.section]
        let food = currentSection.items[selectedIndexPath.row]
        
        return FoodViewModel(foodModel: food)
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
    
    init(foodCategoryId: Int16) {
        self.foodCategoryId = foodCategoryId
        self.sectionListSubject.onNext(
            [SectionOfFoods(
                    header: "",
                    items: CoreDataHelper.sharedInstance.fetchFoodsFromSelectedCategory(foodCategoryId: self.foodCategoryId)
                )
            ]
        )
    }
}
