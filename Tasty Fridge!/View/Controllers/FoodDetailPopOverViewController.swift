//
//  FoodDetailPopOverViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FoodDetailPopOverViewController: UIViewController, UpdateFoodDetailPopOverDelegate {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodShelfLife: UILabel!
    @IBOutlet weak var foodQuantityLabel: UILabel!
    @IBOutlet weak var foodDaysCounterLabel: UILabel!
    @IBOutlet weak var foodQuantityTypeLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var editFoodButton: UIButton!
    
    var foodCellDelegate: UpdateFoodCellDelegate?
    var foodViewModel: FoodViewModelType?
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let foodViewModel = foodViewModel else { return }
        
        foodViewModel.foodName.bind(to: foodNameLabel.rx.text).disposed(by: disposeBag)
        foodViewModel.foodImage.bind(to: foodImageView.rx.image).disposed(by: disposeBag)
        foodViewModel.foodShelfLife.bind(to: foodShelfLife.rx.text).disposed(by: disposeBag)
        foodViewModel.foodQuantity.bind(to: foodQuantityLabel.rx.text).disposed(by: disposeBag)
        foodViewModel.foodQuantityType.bind(to: foodQuantityTypeLabel.rx.text).disposed(by: disposeBag)
        
        let differenceOfDate = getDateFromString(foodDate: foodViewModel.foodShelfLife.value!).interval(ofComponent: .day, fromDate: Date())
        
        if differenceOfDate > 0 {
            foodDaysCounterLabel.text = "(осталось дней: \(differenceOfDate))"
            foodDaysCounterLabel.textColor = .black
        } else {
            foodDaysCounterLabel.text = "срок годности истёк!"
            foodDaysCounterLabel.textColor = .red
        }
        
        editFoodButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "showEditFoodViewSegue", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    func updateFoodDetailPopOverData(foodViewModel: FoodViewModel) {
        self.foodViewModel = foodViewModel
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let foodViewModel = foodViewModel else { return }
        
        if identifier == "showEditFoodViewSegue" {
            let navigationViewController = segue.destination as! UINavigationController
            
            guard let destinationViewController = navigationViewController.topViewController as? EditFoodViewController else { return }
            
            destinationViewController.foodViewModel = foodViewModel
            destinationViewController.foodCellDelegate = foodCellDelegate
            destinationViewController.foodPopOverDelegate = self
        }
    }
}

