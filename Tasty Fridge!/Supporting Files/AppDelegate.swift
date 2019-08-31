//
//  AppDelegate.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationService = NotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadData()
        notificationService.requestAuthorization()
        notificationService.notificationCenter.delegate = notificationService
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasty_Fridge_")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func preloadData() {
        let preloadedDataKey = "didPreloadData"
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: preloadedDataKey) == false {
            guard let foodUrlPath = Bundle.main.url(forResource: "Foods", withExtension: "plist") else { return }
            guard let foodCategoryUrlPath = Bundle.main.url(forResource: "FoodCategories", withExtension: "plist") else { return }
            let backgroundContext = persistentContainer.newBackgroundContext()
            
            backgroundContext.perform {
                let foodArrayContents = NSArray(contentsOf: foodUrlPath)!
                let foodCategoryArrayContents = NSArray(contentsOf: foodCategoryUrlPath)!
                
                for dictionary in foodCategoryArrayContents {
                    let foodCategoryDictionary = dictionary as! NSDictionary
                    let foodCategory = FoodCategory(context: backgroundContext)
                    
                    foodCategory.id = foodCategoryDictionary["id"] as! Int16
                    foodCategory.name = foodCategoryDictionary["name"] as? String
                }
                
                for dictionary in foodArrayContents {
                    let foodDictionary = dictionary as! NSDictionary
                    let food = Food(context: backgroundContext)
                    
                    let imageName = foodDictionary["imageName"] as? String
                    let image = UIImage(named: imageName!)
                    let imageData = image!.pngData()
                    
                    food.image = imageData
                    food.name = foodDictionary["name"] as? String
                    food.quantityType = foodDictionary["quantityType"] as? String
                    food.shelfLife = Date()
                    food.isInTheFridgeNow = false
                    food.foodCategoryId = foodDictionary["foodCategoryId"] as! Int16
                }
                do {
                    try backgroundContext.save()
                    userDefaults.set(true, forKey: preloadedDataKey)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
