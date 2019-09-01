//
//  EditFoodViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditFoodViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodQuantityTextField: UITextField!
    @IBOutlet weak var foodCategoryTextField: UITextField!
    @IBOutlet weak var foodShelfLifeTextField: UITextField!
    @IBOutlet weak var foodCategoryIdTextField: UITextField!
    @IBOutlet weak var updateFoodBarButton: UIBarButtonItem!
    @IBOutlet weak var foodQuantityTypeTextField: UITextField!
    
    var foodViewModel: FoodViewModelType?
    var foodCellDelegate: UpdateFoodCellDelegate?
    var foodPopOverDelegate: UpdateFoodDetailPopOverDelegate?
    private var keyboardType = 0
    private var datePicker: UIDatePicker?
    private var disposeBag = DisposeBag()
    private var foodCategoryPickerView = UIPickerView()
    private var foodQuantityTypePickerView = UIPickerView()
    private var foodQuantityTypePicker: FoodQuantityTypePicker!
    private var foodCategoryPicker: FoodCategoryPicker!
    private weak var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let foodViewModel = foodViewModel else { return }
        
        customizeUI()
        fillUI(foodViewModel: foodViewModel)
        validateFoodData(foodViewModel: foodViewModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func customizeUI() {
        let toolbar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(foodImageViewTapped(_:)))
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        foodCategoryPicker = FoodCategoryPicker()
        foodCategoryPicker.setTextField(textField: foodCategoryTextField)
        foodCategoryPicker.setTextFieldForFoodCategoryId(textField: foodCategoryIdTextField)
        
        foodCategoryPickerView.delegate = foodCategoryPicker
        foodCategoryPickerView.dataSource = foodCategoryPicker
        foodCategoryPickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        
        foodQuantityTypePicker = FoodQuantityTypePicker()
        foodQuantityTypePicker.setTextField(textField: foodQuantityTypeTextField)
        
        foodQuantityTypePickerView.delegate = foodQuantityTypePicker
        foodQuantityTypePickerView.dataSource = foodQuantityTypePicker
        foodQuantityTypePickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        
        foodNameTextField.delegate = self
        foodNameTextField.inputAccessoryView = toolbar
        foodNameTextField.setBottomBorder()
        
        foodCategoryTextField.delegate = self
        foodCategoryTextField.inputAccessoryView = toolbar
        foodCategoryTextField.inputView = foodCategoryPickerView
        foodCategoryTextField.setBottomBorder()
        
        foodShelfLifeTextField.delegate = self
        foodShelfLifeTextField.inputView = datePicker
        foodShelfLifeTextField.inputAccessoryView = toolbar
        foodShelfLifeTextField.setBottomBorder()
        
        foodQuantityTextField.delegate = self
        foodQuantityTextField.inputAccessoryView = toolbar
        foodQuantityTextField.setBottomBorder()
        
        foodQuantityTypeTextField.delegate = self
        foodQuantityTypeTextField.inputAccessoryView = toolbar
        foodQuantityTypeTextField.inputView = foodQuantityTypePickerView
        foodQuantityTypeTextField.setBottomBorder()
        
        foodImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func fillUI(foodViewModel: FoodViewModelType) {
        foodViewModel.foodImage.bind(to: foodImageView.rx.image).disposed(by: disposeBag)
        foodViewModel.foodName.bind(to: foodNameTextField.rx.text).disposed(by: disposeBag)
        foodViewModel.foodQuantity.bind(to: foodQuantityTextField.rx.text).disposed(by: disposeBag)
        foodViewModel.foodCategory.bind(to: foodCategoryTextField.rx.text).disposed(by: disposeBag)
        foodViewModel.foodShelfLife.bind(to: foodShelfLifeTextField.rx.text).disposed(by: disposeBag)
        foodViewModel.foodCategoryId.bind(to: foodCategoryIdTextField.rx.text).disposed(by: disposeBag)
        foodViewModel.foodQuantityType.bind(to: foodQuantityTypeTextField.rx.text).disposed(by: disposeBag)
        
        title = foodViewModel.foodName.value
    }
    
    func validateFoodData(foodViewModel: FoodViewModelType) {
        let foodNameValidator = foodNameTextField.rx.text.map({!$0!.isEmpty})
        let foodCategoryValidator = foodCategoryTextField.rx.text.map({!$0!.isEmpty})
        let foodQuantityValidator = TextValidator(input: foodQuantityTextField.rx.text.asObservable(), regex: try! NSRegularExpression(pattern: "[0-9]"))
        let foodShelfLifeValidator = TextValidator(input: foodShelfLifeTextField.rx.text.asObservable(), regex: try! NSRegularExpression(pattern:
            "^\\s*(3[01]|[12][0-9]|0?[1-9])\\.(1[012]|0?[1-9])\\.((?:19|20)\\d{2})\\s*$"))
        let foodQuantityTypeValidator = foodQuantityTypeTextField.rx.text.map({!$0!.isEmpty})

        let enableBarButton = Observable.combineLatest(foodNameValidator, foodCategoryValidator, foodQuantityValidator.validate(),
                                                       foodShelfLifeValidator.validate(), foodQuantityTypeValidator) {
                                                      (foodName, foodCategory, foodQuantity, foodShelfLife, foodQuantityType) in
                                                        return foodName && foodCategory && foodQuantity && foodShelfLife && foodQuantityType
        }
        
        enableBarButton.bind(to: updateFoodBarButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        updateFoodBarButton.rx.tap.subscribe(onNext: { [weak self] in
            guard
                let self = self,
                let foodCellDelegate = self.foodCellDelegate,
                let foodPopOverDelegate = self.foodPopOverDelegate,
                let image = self.foodImageView.image,
                let imageData = image.pngData()
            else { return }
            
            let oldFoodName = foodViewModel.foodName.value!
            
            self.foodQuantityTypeTextField.rx.text.bind(to: foodViewModel.foodQuantityType).disposed(by: self.disposeBag)
            self.foodCategoryIdTextField.rx.text.bind(to: foodViewModel.foodCategoryId).disposed(by: self.disposeBag)
            self.foodShelfLifeTextField.rx.text.bind(to: foodViewModel.foodShelfLife).disposed(by: self.disposeBag)
            self.foodCategoryTextField.rx.text.bind(to: foodViewModel.foodCategory).disposed(by: self.disposeBag)
            self.foodQuantityTextField.rx.text.bind(to: foodViewModel.foodQuantity).disposed(by: self.disposeBag)
            self.foodNameTextField.rx.text.bind(to: foodViewModel.foodName).disposed(by: self.disposeBag)
            
            foodViewModel.updateFood(oldFoodName: oldFoodName, foodImageData: imageData)
            
            if oldFoodName == foodViewModel.foodName.value! {
                foodCellDelegate.updateFoodCell(foodShelfLife: getDateFromString(foodDate: foodViewModel.foodShelfLife.value!),
                                                foodName: nil, foodImageData: imageData)
            } else {
                foodCellDelegate.updateFoodCell(foodShelfLife: getDateFromString(foodDate: foodViewModel.foodShelfLife.value!),
                                                foodName: foodViewModel.foodName.value!, foodImageData: imageData)
            }
            
            foodPopOverDelegate.updateFoodDetailPopOverData(foodViewModel: foodViewModel.getUpdatedFoodViewModel())
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }
    
    @objc func foodImageViewTapped(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            self?.chooseImagePickerAction(source: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Фото", style: .default) { [weak self] _ in
            self?.chooseImagePickerAction(source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
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

extension EditFoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}

extension EditFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        foodImageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        foodImageView.contentMode = .scaleAspectFill
        
        dismiss(animated: true)
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
