//
//  FridgeCollectionViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FridgeCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private var fridgeViewModel: FridgeCollectionViewViewModelType?
    //private var flag = false
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        fridgeViewModel = FridgeCollectionViewViewModel()
        
        guard let fridgeViewModel = fridgeViewModel else { return }
        let dataSource = createDataSource()
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(removeFoodFromFridge))

        lpgr.minimumPressDuration = 0.4
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        
        collectionView.dataSource = nil
        collectionView.bounces = false
        collectionView.addGestureRecognizer(lpgr)
        
        customizeUI()
        
        fridgeViewModel.sectionListSubject.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard
                let self = self,
                let fridgeViewModel = self.fridgeViewModel,
                let cell = self.collectionView.cellForItem(at: indexPath) as? FridgeCollectionViewCell
            else { return }
            
            //if false == self.flag {
                guard let foodDetailPopOverViewController = self.storyboard?.instantiateViewController(withIdentifier: "foodDetailPopOverViewController") as? FoodDetailPopOverViewController else { return }
                foodDetailPopOverViewController.foodCellDelegate = cell
                foodDetailPopOverViewController.modalPresentationStyle = .popover
                foodDetailPopOverViewController.preferredContentSize = CGSize(width: 450, height: 110)
                foodDetailPopOverViewController.foodViewModel = fridgeViewModel.cellViewModel(atIndexPath: indexPath)
                
                guard let popOverVC = foodDetailPopOverViewController.popoverPresentationController else { return }
                popOverVC.delegate = self
                popOverVC.sourceView = cell
                popOverVC.sourceRect = cell.bounds
                
                self.present(foodDetailPopOverViewController, animated: true)
//            } else {
//                cell.foodImageView.alpha = 1.0
//            }
        }).disposed(by: disposeBag)
        /*
        lng.rx.event.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            switch $0.state {
            case .possible:
                print("possible")
            case .began:
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: $0.location(in: self.collectionView)) else { break }
                self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                self.collectionView.updateInteractiveMovementTargetPosition($0.location(in: $0.view!))
            case .ended:
                self.collectionView.endInteractiveMovement()
            case .cancelled:
                self.collectionView.cancelInteractiveMovement()
            case .failed:
                 print("failed")
            @unknown default:
                print("default")
            }
        }).disposed(by: disposeBag)*/
    }
    
    func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<SectionOfFoods> {
        return RxCollectionViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .left), configureCell:
            { (_, collectionView, indexPath, food) in
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FridgeCollectionViewCell.cellIdentifier, for: indexPath) as? FridgeCollectionViewCell else { return UICollectionViewCell() }
                cell.foodViewModel = FoodViewModel(foodModel: food)
                
//                if false == self?.flag {
//                    cell.foodImageView.alpha = 1.0
//                } else {
//                    cell.foodImageView.alpha = 0.5
//                }
                
                return cell
            }
//            canMoveItemAtIndexPath: { _, _ in
//                return true
//            }
        )
    }
    
//    @IBAction func bbiPressed(sender: Any) {
//        flag.toggle()
//        collectionView.reloadData()
//    }
    
    @objc func removeFoodFromFridge(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .ended { return }

        let point = gesture.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: point) {
            guard let fridgeViewModel = fridgeViewModel else { return }
            fridgeViewModel.removeSelectedFoodFromFridge(forIndexPath: indexPath)
        }
    }
    
    func customizeUI() {
        if DeviceType.iPhoneSE {
            createUI(fridgeHeader: "fridge header 2x", fridgeSectionBlock: "big section block 2x",
                     sectionInsetTop: 14, sectionInsetLeft: 10, sectionInsetBottom: 0, sectionInsetRight: 10, cellHeight: 106, minimumLineSpacing: 14)
        } else if DeviceType.iPhone8 {
            createUI(fridgeHeader: "fridge header-2x-6 model", fridgeSectionBlock: "test3",
                     sectionInsetTop: 27.2, sectionInsetLeft: 11, sectionInsetBottom: 0, sectionInsetRight: 11, cellHeight: 112, minimumLineSpacing: 28.03)
        } else if DeviceType.iPhone8Plus {
            createUI(fridgeHeader: "fridge header 3x-6-plus model-virtual", fridgeSectionBlock: "big section block 3x-6-plus model-virtual2",
                     sectionInsetTop: 29, sectionInsetLeft: 12, sectionInsetBottom: 0, sectionInsetRight: 12, cellHeight: 112.5, minimumLineSpacing: 29.85)
        } else if DeviceType.iPhoneXs {
            createUI(fridgeHeader: "fridge header-2x-6 model", fridgeSectionBlock: "big section block 3x-X-XS model",
                     sectionInsetTop: 31, sectionInsetLeft: 10, sectionInsetBottom: 0, sectionInsetRight: 10, cellHeight: 115, minimumLineSpacing: 31.7)
        } else if DeviceType.iPhoneXsMax {
            createUI(fridgeHeader: "fridge header-2x-6 model", fridgeSectionBlock: "big section block XS max2",
                     sectionInsetTop: 40, sectionInsetLeft: 10, sectionInsetBottom: 0, sectionInsetRight: 10, cellHeight: 108.8, minimumLineSpacing: 39.85)
        } else if DeviceType.iPhoneXr {
            createUI(fridgeHeader: "fridge header-2x-6 model", fridgeSectionBlock: "big section block XR model2",
                     sectionInsetTop: 33.6, sectionInsetLeft: 10, sectionInsetBottom: 0, sectionInsetRight: 10, cellHeight: 114, minimumLineSpacing: 34)
        } else {
            print("Неизвестная модель айфона")
        }
    }
    
    func createUI(fridgeHeader: String, fridgeSectionBlock: String, sectionInsetTop: Float, sectionInsetLeft: Int,
                  sectionInsetBottom: Int, sectionInsetRight: Int, cellHeight: Double, minimumLineSpacing: Float) {
        guard let image = UIImage(named: fridgeHeader) else { return }
        let imageView = UIImageView(image: image)
        //прижимаем хедер к верху
        imageView.frame = CGRect(x: 0, y: -20, width: collectionView.frame.size.width, height: 20)
        collectionView.addSubview(imageView)
        //скроллим вниз на 20 пунктов
        collectionView.contentInset.top = 20
        collectionView.backgroundColor = UIColor(patternImage: UIImage(named: fridgeSectionBlock)!)
        //позиционируем ячейки
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: CGFloat(sectionInsetTop), left: CGFloat(sectionInsetLeft),
                                           bottom: CGFloat(sectionInsetBottom), right: CGFloat(sectionInsetRight))
        layout.itemSize = CGSize(width: 70, height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = CGFloat(minimumLineSpacing)
        collectionView.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let navigationViewController = segue.destination as? UINavigationController else { return }
        
        if identifier == "showFoodCategoriesSegue" {
            if let destinationViewController = navigationViewController.topViewController as? FoodCategoriesTableViewController {
                destinationViewController.fridgeViewModel = self.fridgeViewModel
            }
        }
    }
}

extension FridgeCollectionViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
