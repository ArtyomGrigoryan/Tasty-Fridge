//
//  FoodCategoryDetailTableViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FoodCategoryDetailTableViewController: UITableViewController {
    var foodCategoryDetailViewModel: FoodCategoryDetailTableViewViewModelType?
    var fridgeViewModel: FridgeCollectionViewViewModelType?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let foodCategoryDetailViewModel = foodCategoryDetailViewModel else { return }
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = foodCategoryDetailViewModel.customizeUI()
        
        let dataSource = createDataSource()
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in return true }
        
        foodCategoryDetailViewModel.sectionListSubject.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: {
            if let foodName = foodCategoryDetailViewModel.checkSelectedFoodForPresenceInTheFridge(indexPath: $0) {
                let alertController = UIAlertController(title: "\(String(describing: foodName))",
                    message: "невозможно удалить, так как он добавлен в холодильник",
                    preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Закрыть", style: .default)
                alertController.addAction(closeAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                guard let foodCategoryDetailViewModel = self.foodCategoryDetailViewModel else { return }
                foodCategoryDetailViewModel.removeFoodFromApplication(at: $0)
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            if let foodName = foodCategoryDetailViewModel.checkSelectedFoodForPresenceInTheFridge(indexPath: indexPath) {
                //если выбранный пользователем продукт уже имеется в холодильнике, то выдадим соответствующее сообщение
                let alertController = UIAlertController(title: "\(String(describing: foodName))",
                    message: "уже добавлен в холодильник!",
                    preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Закрыть", style: .default)
                alertController.addAction(closeAction)
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.present(alertController, animated: true, completion: nil)
            } else {
                //если отсутствует, то перейдем к контроллеру добавления продукта в холодильник
                self.performSegue(withIdentifier: "showAddFoodControllerSegue", sender: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func createDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionOfFoods> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .left), configureCell:
            { (_, tableView, indexPath, food) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCategoryDetailTableViewCell.cellIdentifier, for: indexPath) as? FoodCategoryDetailTableViewCell else { return UITableViewCell() }
                cell.foodCategoryDetailCellViewModel = FoodTableViewCellViewModel(foodModel: food)
                return cell
            }
        )
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let foodCategoryDetailViewModel = foodCategoryDetailViewModel else { return }
        
        if identifier == "showAddFoodControllerSegue" {
            if let dvc = segue.destination as? AddFoodViewController {
                dvc.foodViewModel = foodCategoryDetailViewModel.getViewModelForSelectedFood()
                dvc.fridgeViewModel = fridgeViewModel
            }
        }
    }
}
