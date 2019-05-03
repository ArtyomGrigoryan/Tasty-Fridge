//
//  SectionOfFoods.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxDataSources

struct SectionOfFoods {
    var header: String?
    var items: [Food]
}

extension SectionOfFoods: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String {
        return self.header ?? ""
    }
    
    init(original: SectionOfFoods, items: [Food]) {
        self = original
        self.items = items
    }
}
