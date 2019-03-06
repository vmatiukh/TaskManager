//
//  Task+CoreDataProperties.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var priorityString: String?
    @NSManaged public var priorityKey: Int16

}
