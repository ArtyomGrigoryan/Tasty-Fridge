//
//  FridgeCollectionViewCell.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift

class FridgeCollectionViewCell: UICollectionViewCell, UpdateFoodCellDelegate {
    @IBOutlet weak var foodNameTextLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodQuantityBadgeLabel: BadgeSwift!
    
    static let cellIdentifier = "FridgeCell"
    private let disposeBag = DisposeBag()
    
    var foodViewModel: FoodViewModelType? {
        willSet(foodViewModel) {
            guard let foodViewModel = foodViewModel else { return }
            
            foodViewModel.foodName.bind(to: foodNameTextLabel.rx.text).disposed(by: disposeBag)
            foodViewModel.foodImage.bind(to: foodImageView.rx.image).disposed(by: disposeBag)
            
            let foodShelfLife = getDateFromString(foodDate: foodViewModel.foodShelfLife.value!)
         
            updateFoodCell(foodShelfLife: foodShelfLife, foodName: nil, foodImageData: nil,
                           foodQuantity: foodViewModel.foodQuantity.value, foodQuantityType: foodViewModel.foodQuantityType.value)
        }
    }
    
    func updateFoodCell(foodShelfLife: Date, foodName: String?, foodImageData: Data?, foodQuantity: String?, foodQuantityType: String?) {
        let currentDate = getDateFromString(foodDate: getCurrentDateString())
     
        if currentDate < foodShelfLife {
            foodNameTextLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            foodNameTextLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        if let foodName = foodName {
            foodNameTextLabel.text = foodName
        }
        
        if let foodImage = foodImageData {
            foodImageView.image = UIImage(data: foodImage)
        }

        if let foodQuantity = foodQuantity, let foodQuantityType = foodQuantityType {
            if foodQuantity.count < 4 {
                 foodQuantityBadgeLabel.text = "\(foodQuantity) \(foodQuantityType)"
            } else {
                let resultFloat = Float(foodQuantity)! * (1/1000)
                let resultString = String(format: "%.1f", resultFloat)
                
                switch foodQuantityType {
                case "мл.":
                    foodQuantityBadgeLabel.text = "\(resultString) л."
                case "гр.":
                    foodQuantityBadgeLabel.text = "\(resultString) кг."
                default:
                    foodQuantityBadgeLabel.text = "\(foodQuantity) шт."
                }
            }
        }
    }
}
