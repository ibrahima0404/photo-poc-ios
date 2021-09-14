//
//  CoreDataStore.swift
//  App
//
//  Created by Ibrahima KH GUEYE on 13/09/2021.
//

import Foundation
import CoreData

class CoreDataStore {
    public static let shared = CoreDataStore()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = SharePersistentContainer(name: "CoreDataShareStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
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
    
    func storeShareAttachement(image: String?, file: String?, audio: String?) {
        let managedContext = self.persistentContainer.viewContext
        let shareEntity = ShareEntity(context: managedContext)
        shareEntity.audio = audio
        shareEntity.file = file
        shareEntity.image = image
        saveContext()
    }
    
    func clearCoreDataStore() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ShareEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let taskContext = persistentContainer.viewContext

        do {
            try taskContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error clear CoreData \(error.localizedDescription)")
        }
    }
    
    func getSharedAttachement() -> ShareEntity? {
        let resquest = NSFetchRequest<ShareEntity>(entityName: "ShareEntity")
        
        guard let shareEntities = try? persistentContainer.viewContext.fetch(resquest) else {
            return nil
        }
        return shareEntities.first
    }
}
