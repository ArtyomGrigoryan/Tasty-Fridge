//
//  TextValidator.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import RxSwift
import Foundation

class TextValidator {
    var input: Observable<String?>
    var regex: NSRegularExpression
    
    init(input: Observable<String?>, regex: NSRegularExpression) {
        self.input = input
        self.regex = regex
    }
    
    func validate() -> Observable<Bool> {
        return input.map { text in
            guard let text = text else { return false }
            let range = NSRange(text.startIndex..., in: text)
            return self.regex.firstMatch(in: text, options: [], range: range) != nil
        }
    }
}
