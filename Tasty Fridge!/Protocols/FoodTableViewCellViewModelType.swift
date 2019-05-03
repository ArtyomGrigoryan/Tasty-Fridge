//
//  FoodTableViewCellViewModelType.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxCocoa

protocol FoodTableViewCellViewModelType: class {
    var foodName: BehaviorRelay<String?> { get }
    func setFontSize() -> UIFont?
}
