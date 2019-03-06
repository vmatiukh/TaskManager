//
//  NestedSingleValueDecodingContainer.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//
//

import Foundation


class NestedSingleValueDecodingContainer<Key: CodingKey>: SingleValueDecodingContainer {
    let container: KeyedDecodingContainer<Key>
    let key: Key
    var codingPath: [CodingKey] {
        return container.codingPath
    }
    
    init(container: KeyedDecodingContainer<Key>, key: Key) {
        self.container = container
        self.key = key
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        return try container.decode(type, forKey: key)
    }
    
    func decode(_ type: String.Type) throws -> String {
        return try container.decode(type, forKey: key)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try container.decode(type, forKey: key)
    }
    
    func decodeNil() -> Bool {
        return (try? container.decodeNil(forKey: key)) ?? false
    }
}
