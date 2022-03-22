//
//  CoreDataManager.swift
//  BIS
//
//  Created by TSSIOS on 29/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import CoreData
import EncryptedCoreData
import Foundation

class CoreDataManager: NSObject {

    var errorHandler: (Error) -> Void = { _ in /*initially empty */ }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BIS")
        var password = String()
        if let obj: OtpDTO = UserDefaultsService().getOTP() {
            password = obj.userName
        }
        let optionsDictionary = [EncryptedStorePassphraseKey: password, EncryptedStoreFileManagerOption: EncryptedStoreFileManager.default() as Any] as [String: Any]
        
        var description: NSPersistentStoreDescription? = try? EncryptedStore.makeDescription(options: optionsDictionary, configuration: nil)
        container.persistentStoreDescriptions = [description!]
        container.loadPersistentStores(completionHandler: { [weak self] _, error in
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.overwrite
        return self.persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true

        context.mergePolicy = NSMergePolicy.overwrite
        return context
    }()

    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }

    func deleteAllData(entity: String) {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
