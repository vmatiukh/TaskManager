//
//  Task+CoreDataClass.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject, Codable, DecoderUpdatable {
    
    enum CodingKeys:String, CodingKey {
        case id, title, date = "dueBy", priority
    }
    
    enum Priority:String {
        case none = "", low = "Low", medium = "Normal", high = "High"
        var title:String {
            switch self {
            case .medium:
                return "Medium"
            default:
                return self.rawValue
            }
        }
    }
    
    var priority:Priority {
        return Priority(rawValue: self.priorityString ?? "") ?? .none
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let context = DataManager.shared.managedContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        try self.update(from: decoder)
    }
    
    func update(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        if let timeInterval = try container.decodeIfPresent(Int64.self, forKey: .date) {
            self.date = Date(timeIntervalSince1970: Double(timeInterval)) as NSDate
        }
        self.priorityString = try container.decodeIfPresent(String.self, forKey: .priority)
        switch self.priority {
        case .none:
            self.priorityKey = 0
            break
        case .low:
            self.priorityKey = 1
            break
        case .medium:
            self.priorityKey = 2
            break
        case .high:
            self.priorityKey = 3
            break
        }
        
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        if let date = date {
            let timeInterval = Int(date.timeIntervalSince1970)
            try container.encodeIfPresent(String(timeInterval), forKey: .date)
        }
        try container.encodeIfPresent(priorityString, forKey: .priority)
    }
}
