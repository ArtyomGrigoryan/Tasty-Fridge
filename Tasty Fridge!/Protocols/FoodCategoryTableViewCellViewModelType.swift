//
//  FoodCategoryTableViewCellViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa

protocol FoodCategoryTableViewCellViewModelType: class {
    var foodCategoryName: BehaviorRelay<String?> { get }
    func setFontSize() -> UIFont?
}
