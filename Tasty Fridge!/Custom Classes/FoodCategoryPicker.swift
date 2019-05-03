//
//  FoodCategoryPicker.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class FoodCategoryPicker: UIPickerView {
    let foodCategoryPickerData = CoreDataHelper.sharedInstance.fetchFoodCategories()
    var textFieldForFoodCategoryId: UITextField?
    var textField: UITextField?
    
    func setTextField(textField: UITextField) {
        self.textField = textField
    }
    
    func setTextFieldForFoodCategoryId(textField: UITextField) {
        self.textFieldForFoodCategoryId = textField
    }
}

extension FoodCategoryPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodCategoryPickerData.count
    }
}

extension FoodCategoryPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodCategoryPickerData[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField?.text = foodCategoryPickerData[row].name!
        self.textFieldForFoodCategoryId?.text = String(describing: foodCategoryPickerData[row].id)
    }
}
