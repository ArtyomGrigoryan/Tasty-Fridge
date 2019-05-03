//
//  FoodQuantityTypePicker.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class FoodQuantityTypePicker: UIPickerView {
    let foodQuantityTypeData = ["гр.", "мл.", "шт."]
    var textField: UITextField?
    
    func setTextField(textField: UITextField) {
        self.textField = textField
    }
}

extension FoodQuantityTypePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodQuantityTypeData.count
    }
}

extension FoodQuantityTypePicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodQuantityTypeData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField?.text = foodQuantityTypeData[row]
    }
}
