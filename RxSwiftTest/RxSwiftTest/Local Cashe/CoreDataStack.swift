//
//  CoreDataStack.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let shared = CoreDataStack()
    
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
}
