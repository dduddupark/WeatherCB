//
//  CoreDataManager.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/04/04.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "CoreAddress"
    
    func getCoreAddress(ascending: Bool = false) -> [CoreAddress] {
        var model: [CoreAddress] = [CoreAddress]()
        
        if let context = context {
            let addressSort: NSSortDescriptor = NSSortDescriptor(key: "address", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [addressSort]
            
            do {
                if let fetchResult: [CoreAddress] = try context.fetch(fetchRequest) as? [CoreAddress] {
                    model = fetchResult
                }
            } catch let error as NSError {
                print("데이터 못찾음 : \(error)")
            }
        }
        
        print("model = \(model)")
        
        return model
    }
    
    func saveCoreAddress(myAddress: MyAddress, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context,
           let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            if let address: CoreAddress = NSManagedObject(entity: entity, insertInto: context) as? CoreAddress {
                address.stateName = myAddress.stateName
                address.address = myAddress.address
                address.isSelected = myAddress.isSelected
                
                contextSave { success in
                           onSuccess(success)
                       }
            }
        }
    }
    
    func selectedCoreAddress(address: CoreAddress, onSuccess: @escaping ((Bool) -> Void)) {
        for item in getCoreAddress() {
            item.isSelected = (item.address == address.address)
        }
    
        contextSave { success in
                   onSuccess(success)
        }
    }
    
    func deleteCoreAddress(address: CoreAddress, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(address: address.address ?? "")
        
        do {
            if let results: [CoreAddress] = try context?.fetch(fetchRequest) as? [CoreAddress] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
                   onSuccess(success)
               }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(address: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "address = %@", NSString(string: address))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
