//
//  CoreDataManager.swift
//  YXEDU
//
//  Created by Jake To on 11/8/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import CoreData

struct YXCoreDataManager {
    static let `shared` = YXCoreDataManager()
    private init() {
        persistentContainer = NSPersistentContainer(name: "YXCoreWordBookModel")
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard let error = error else { return }
            fatalError(error.localizedDescription)
        }
    }
    
    private let persistentContainer: NSPersistentContainer!
    
    var viewContext: NSManagedObjectContext! {
        return persistentContainer.viewContext
    }
    
//    func save() {
//        guard viewContext.hasChanges else { return }
//
//        do {
//            try viewContext.save()
//
//        } catch {
//            print("Cannot save change ,error: \(error.localizedDescription)")
//        }
//    }
}
