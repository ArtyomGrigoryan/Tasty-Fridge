//
//  FoodCategoriesTableViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FoodCategoriesTableViewController: UITableViewController {
    var fridgeViewModel: FridgeCollectionViewViewModelType?
    private var foodCategoriesViewModel: FoodCategoriesTableViewViewModelType?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodCategoriesViewModel = FoodCategoriesTableViewViewModel()
        
        guard let foodCategoriesViewModel = foodCategoriesViewModel else { return }
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = foodCategoriesViewModel.customizeUI()
        
        foodCategoriesViewModel.foodCategories
            .bind(to: tableView.rx.items(cellIdentifier: FoodCategoryTableViewCell.cellIdentifier, cellType: FoodCategoryTableViewCell.self))
            { [weak self] (row, food, cell) in
                guard let self = self, let foodCategoriesViewModel = self.foodCategoriesViewModel else { return }
                cell.foodCategoryCellViewModel = foodCategoriesViewModel.cellViewModel(forRow: row)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self, let foodCategoriesViewModel = self.foodCategoriesViewModel else { return }
            foodCategoriesViewModel.selectRow(atIndexPath: indexPath)
            self.performSegue(withIdentifier: "showFoodsInSelectedCategorySegue", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let foodCategoriesViewModel = foodCategoriesViewModel
        else { return }
        
        if identifier == "showFoodsInSelectedCategorySegue" {
            guard let dvc = segue.destination as? FoodCategoryDetailTableViewController else { return }
            dvc.foodCategoryDetailViewModel = foodCategoriesViewModel.getFoodCategoryDetailViewModelForSelectedRow()
            dvc.fridgeViewModel = fridgeViewModel
        }
        
        if identifier == "showNewFoodControllerSegue" {
            guard
                let navigationViewController = segue.destination as? UINavigationController,
                let destinationViewController = navigationViewController.topViewController as? NewFoodViewController
            else { return }
            destinationViewController.fridgeViewModel = fridgeViewModel
        }
        
        if identifier == "showSearchFoodControllerSegue" {
            guard let dvc = segue.destination as? SearchFoodsTableViewController else { return }
            navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
            dvc.fridgeViewModel = fridgeViewModel
        }
    }
    
    @IBAction func unwindFromNewFood(segue: UIStoryboardSegue) {}
}
