//
//  CoreDataHelper.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    static let sharedInstance = CoreDataHelper()
    
    private override init() {}
    
    func saveNewFood(foodName: String, foodQuantity: Int16, foodQuantityType: String, foodShelfLife: Date, foodImageData: Data, foodCategoryId: Int16) {
        let context = managedObjectContext()
        let food = Food(context: context)

        food.name = foodName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        food.quantityType = foodQuantityType
        food.foodCategoryId = foodCategoryId
        food.shelfLife = foodShelfLife
        food.isInTheFridgeNow = true
        food.quantity = foodQuantity
        food.image = foodImageData

        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchFoodsThatsInTheFridgeNow() -> [Food] {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var foods: [Food] = []
    
        fetchRequest.predicate = NSPredicate(format: "isInTheFridgeNow == YES")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            foods = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return foods
    }
    
    func getFoodCategoryName(foodCategoryId: Int16) -> String? {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<FoodCategory> = FoodCategory.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", foodCategoryId as NSNumber)
        
        do {
            let selectedCategory = try context.fetch(fetchRequest)[0]
            return selectedCategory.name!
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchAllFoods() -> [Food] {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        var foods: [Food] = []
        
        do {
            foods = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return foods
    }
    
    func fetchFoodCategories() -> [FoodCategory] {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<FoodCategory> = FoodCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        var foodCategories: [FoodCategory] = []
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            foodCategories = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return foodCategories
    }
    
    func fetchFoodsFromSelectedCategory(foodCategoryId: Int16) -> [Food] {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var foods: [Food] = []
        
        fetchRequest.predicate = NSPredicate(format: "foodCategoryId == %@", foodCategoryId as NSNumber)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            foods = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return foods
    }
    
    func removeFoodFromApplication(foodName: String) {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", foodName)
        
        do {
            let foodToDelete = try context.fetch(fetchRequest)[0]
            foodToDelete.isInTheFridgeNow = false
            context.delete(foodToDelete)
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeFoodFromFridge(foodName: String) {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", foodName)
        
        do {
            let selectedProduct = try context.fetch(fetchRequest)[0]
            
            selectedProduct.setValue(nil, forKey: "quantity")
            selectedProduct.setValue(nil, forKey: "shelfLife")
            selectedProduct.setValue(false, forKey: "isInTheFridgeNow")
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addFoodToFridge(foodName: String, foodQuantity: Int16, foodQuantityType: String, foodShelfLife: Date) {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", foodName)
        
        do {
            let selectedFood = try context.fetch(fetchRequest)[0]
            
            selectedFood.setValue(foodQuantityType, forKey: "quantityType")
            selectedFood.setValue(foodShelfLife, forKey: "shelfLife")
            selectedFood.setValue(foodQuantity, forKey: "quantity")
            selectedFood.setValue(true, forKey: "isInTheFridgeNow")
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateFood(oldFoodName: String, newFoodName: String, foodQuantity: Int16, foodQuantityType: String,
                    foodCategoryId: Int16, foodShelfLife: Date, foodImageData: Data) -> Food? {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", oldFoodName)
        
        do {
            let selectedFood = try context.fetch(fetchRequest)[0]
            
            guard let image = UIImage(data: foodImageData) else { return nil }
            guard let selectedFoodUIImage = UIImage(data: selectedFood.image!) else { return nil }
            
            selectedFood.setValue(newFoodName.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "name")
            selectedFood.setValue(foodQuantityType, forKey: "quantityType")
            selectedFood.setValue(foodCategoryId, forKey: "foodCategoryId")
            selectedFood.setValue(foodShelfLife, forKey: "shelfLife")
            selectedFood.setValue(foodQuantity, forKey: "quantity")
            selectedFood.setValue(true, forKey: "isInTheFridgeNow")
            
            if !image.isEqualToImage(image: selectedFoodUIImage) {
                guard let imageData = image.jpeg(.lowest) else { return nil }
                selectedFood.setValue(imageData, forKey: "image")
            }
            
            do {
                try context.save()
                return selectedFood
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func checkEqualFoodName(foodName: String) -> Bool {
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", foodName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count != 0 {
                return true
            } else {
                return false
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return true
    }

    private func managedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
