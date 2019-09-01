//
//  AddFoodViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddFoodViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodQuantityTextField: UITextField!
    @IBOutlet weak var foodShelfLifeTextField: UITextField!
    @IBOutlet weak var foodQuantityTypeTextField: UITextField!
    @IBOutlet weak var addFoodToFridgeBarButton: UIBarButtonItem!
    
    var foodViewModel: FoodViewModelType?
    var fridgeViewModel: FridgeCollectionViewViewModelType?
    private var datePicker: UIDatePicker?
    private var disposeBag = DisposeBag()
    private var foodQuantityTypePickerView = UIPickerView()
    private var foodQuantityTypePicker: FoodQuantityTypePicker!
    private weak var activeField: UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let foodViewModel = foodViewModel else { return }
        
        customizeUI()
        fillUI(foodViewModel: foodViewModel)
        validateFoodData(foodViewModel: foodViewModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func customizeUI() {
        let toolbar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        foodQuantityTypePicker = FoodQuantityTypePicker()
        foodQuantityTypePicker.setTextField(textField: foodQuantityTypeTextField)
        
        foodQuantityTypePickerView.delegate = foodQuantityTypePicker
        foodQuantityTypePickerView.dataSource = foodQuantityTypePicker
        foodQuantityTypePickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        
        foodShelfLifeTextField.delegate = self
        foodShelfLifeTextField.inputView = datePicker
        foodShelfLifeTextField.inputAccessoryView = toolbar
        foodShelfLifeTextField.setBottomBorder()
        foodShelfLifeTextField.font = setFontSize()
        
        foodQuantityTextField.delegate = self
        foodQuantityTextField.inputAccessoryView = toolbar
        foodQuantityTextField.setBottomBorder()
        foodQuantityTextField.font = setFontSize()
        
        foodQuantityTypeTextField.delegate = self
        foodQuantityTypeTextField.inputAccessoryView = toolbar
        foodQuantityTypeTextField.inputView = foodQuantityTypePickerView
        foodQuantityTypeTextField.setBottomBorder()
        foodQuantityTypeTextField.font = setFontSize()
    }
    
    func fillUI(foodViewModel: FoodViewModelType) {
        foodViewModel.foodImage.bind(to: foodImageView.rx.image).disposed(by: disposeBag)
        foodViewModel.foodQuantityType.bind(to: foodQuantityTypeTextField.rx.text).disposed(by: disposeBag)
        
        title = foodViewModel.foodName.value
    }
    
    func validateFoodData(foodViewModel: FoodViewModelType) {
        let foodQuantityValidation = foodQuantityTextField.rx.text.map({!$0!.isEmpty})
        let foodShelfLifeValidation = TextValidator(input: foodShelfLifeTextField.rx.text.asObservable(), regex: try! NSRegularExpression(pattern:
            "^\\s*(3[01]|[12][0-9]|0?[1-9])\\.(1[012]|0?[1-9])\\.((?:19|20)\\d{2})\\s*$"))
        let foodQuantityTypeValidation = foodQuantityTypeTextField.rx.text.map({!$0!.isEmpty})
        
        let enableBarButton = Observable.combineLatest(foodQuantityValidation, foodShelfLifeValidation.validate(), foodQuantityTypeValidation) {
            (foodQuantity, foodShelfLife, foodQuantityType) in
            return foodQuantity && foodShelfLife && foodQuantityType
        }
        
        enableBarButton.bind(to: addFoodToFridgeBarButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        addFoodToFridgeBarButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let fridgeViewModel = self.fridgeViewModel else { return }
            
            self.foodQuantityTypeTextField.rx.text.bind(to: foodViewModel.foodQuantityType).disposed(by: self.disposeBag)
            self.foodShelfLifeTextField.rx.text.bind(to: foodViewModel.foodShelfLife).disposed(by: self.disposeBag)
            self.foodQuantityTextField.rx.text.bind(to: foodViewModel.foodQuantity).disposed(by: self.disposeBag)
            
            foodViewModel.addFoodToFridge(fridgeViewModel: fridgeViewModel)
            
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setFontSize() -> UIFont? {
        let fontName = "Helvetica Neue"
        
        if DeviceType.iPhoneSE {
            return UIFont(name: fontName, size: 20)
        } else if DeviceType.iPhone8 {
            return UIFont(name: fontName, size: 22)
        } else if DeviceType.iPhone8Plus || DeviceType.iPhoneXs || DeviceType.iPhoneXr || DeviceType.iPhoneXsMax {
            return UIFont(name: fontName, size: 28)
        } else {
            return nil
        }
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard
            let activeField = activeField,
            let userInfo = notification.userInfo,
            let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbFrameSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.scrollRectToVisible(activeField.frame, animated: true)
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
    }
    
    @objc func kbDidHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        foodShelfLifeTextField.text = getStringFromDate(foodDate: sender.date)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension AddFoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
