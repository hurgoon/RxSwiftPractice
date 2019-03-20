//
//  Event+CoreDataProperties.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 20/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var type: String
    @NSManaged public var repoName: String
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: URL
    @NSManaged public var userName: String

}
