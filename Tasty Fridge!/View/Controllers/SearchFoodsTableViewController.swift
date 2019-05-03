//
//  SearchFoodsTableViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchFoodsTableViewController: UITableViewController {
    var fridgeViewModel: FridgeCollectionViewViewModelType?
    private var searchFoodViewModel: SearchFoodsTableViewViewModelType?
    private var searchController: UISearchController!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFoodViewModel = SearchFoodsTableViewViewModel()
        
        guard let searchFoodViewModel = self.searchFoodViewModel else { return }
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "поиск продуктов..."
        
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = searchFoodViewModel.customizeUI()
        
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { query in
            if query.isEmpty {
                searchFoodViewModel.shownFoods.onNext([])
            } else {
                searchFoodViewModel.shownFoods.onNext(searchFoodViewModel.foods.filter { $0.name!.hasPrefix(query) })
            }
        }).disposed(by: disposeBag)
        
        searchFoodViewModel.shownFoods.bind(to: tableView.rx.items(cellIdentifier: FoundFoodTableViewCell.cellIdentifier, cellType: FoundFoodTableViewCell.self))
        { _, food, cell in
            cell.foundFoodCellViewModel = searchFoodViewModel.cellViewModel(forRow: food.name!)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            guard let searchFoodViewModel = self.searchFoodViewModel else { return }
            
            if let foodName = searchFoodViewModel.checkSelectedFoodForPresenceInTheFridge(atIndexPath: indexPath) {
                let alertController = UIAlertController(title: "\(String(describing: foodName))",
                    message: "уже добавлен в холодильник!",
                    preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Закрыть", style: .default)
                alertController.addAction(closeAction)
                
                self.present(alertController, animated: true)
            } else {
                searchFoodViewModel.selectRow(atIndexPath: indexPath)
                self.performSegue(withIdentifier: "showAddFoodControllerSegue", sender: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let searchFoodViewModel = searchFoodViewModel else { return }
        
        if identifier == "showAddFoodControllerSegue" {
            if let dvc = segue.destination as? AddFoodViewController {
                dvc.foodViewModel = searchFoodViewModel.foodViewModelForSelectedRow()
                dvc.fridgeViewModel = fridgeViewModel
            }
        }
    }
}
