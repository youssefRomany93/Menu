//
//  CoreDataManager.swift
//  Menu
//
//  Created by YoussefRomany on 21/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()

    
    // MARK: - Core Data Main Functions

    lazy var managedContext = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Menu")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved context")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil)->[T]?{
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                return result as? [T]
            } else {
                print("No saved objects")
            }
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteAllRecordsInEntity(_ entityName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)
            print("deleted all records in \(entityName)")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

    
extension CoreDataManager {
    
    func saveCategoriesData(_ categories: [DataModel]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for cat in categories {
            let newCat = NSEntityDescription.insertNewObject(forEntityName: "CategoryOffline", into: context)
            newCat.setValue(cat.id, forKey: "id")
            newCat.setValue(cat.name, forKey: "name")
            newCat.setValue(cat.name_localized, forKey: "name_localized")
            newCat.setValue(cat.reference, forKey: "reference")
            newCat.setValue(cat.image, forKey: "image")
            newCat.setValue(cat.created_at, forKey: "created_at")
            newCat.setValue(cat.updated_at, forKey: "updated_at")
            newCat.setValue(cat.deleted_at, forKey: "deleted_at")
        }
        do {
            try context.save()
            print("SuccessSaveData")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func getCategories() -> [CategoryOffline]{
        guard let cats = fetch(CategoryOffline.self) else { return [] }
        return cats
    }

    
    func saveproductsData(_ products: [DataModel]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for product in products {
            let newProduct = NSEntityDescription.insertNewObject(forEntityName: "ProductOffline", into: context)
            newProduct.setValue(product.id, forKey: "id")
            newProduct.setValue(product.name, forKey: "name")
            newProduct.setValue(product.name_localized, forKey: "name_localized")
            newProduct.setValue(product.image, forKey: "image")
            newProduct.setValue(product.price, forKey: "price")
            newProduct.setValue(product.category?.name, forKey: "category")
        }
        do {
            try context.save()
            print("SuccessSaveData Product")
        } catch {
            print("Error saving: \(error)")
        }
    }

    func getProducts() -> [ProductOffline]{
        guard let product = fetch(ProductOffline.self) else { return [] }
        return product
    }
    
}
