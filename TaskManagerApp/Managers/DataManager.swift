//
//  DataManager.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import CoreData

class DataManager {
    static let shared = DataManager()
    
    private let persistentCoordinator: NSPersistentContainer!
    var managedContext: NSManagedObjectContext {
        return persistentCoordinator.viewContext
    }
    
    init(completion:(()->())? = nil) {
        persistentCoordinator = NSPersistentContainer(name: "TaskManagerApp")
        let description = NSPersistentStoreDescription()
        
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        persistentCoordinator.persistentStoreDescriptions = [description]
        persistentCoordinator.loadPersistentStores { (descroption, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            self.persistentCoordinator.viewContext.mergePolicy = NSOverwriteMergePolicy
            completion?()
        }
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
}

extension DataManager {
    func createOrLoadTask(dict:[String:Any]) -> Task {
        let decoder = JSONDecoder()
        if let id = dict["id"] as? Int, var task = self.fetchTask(byId: id) {
            try! decoder.update(&task, from: JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted))
            return task
        }
       
        return try! decoder.decode(Task.self, from: JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted))
    }
    
    func fetchTask(byId id:Int) -> Task? {
        let fetchRequest:NSFetchRequest = Task.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        return try! managedContext.fetch(fetchRequest).first
    }
    
    func delete(task:Task) {
        self.managedContext.delete(task)
    }
}
