//
//  NeastedDecoder.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//
//

import Foundation

class NestedDecoder<Key: CodingKey>: Decoder {
    let container: KeyedDecodingContainer<Key>
    let key: Key
    
    init(from container: KeyedDecodingContainer<Key>, key: Key, userInfo: [CodingUserInfoKey : Any] = [:]) {
        self.container = container
        self.key = key
        self.userInfo = userInfo
    }
    
    var userInfo: [CodingUserInfoKey : Any]
    
    var codingPath: [CodingKey] {
        return container.codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return try container.nestedContainer(keyedBy: type, forKey: key)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try container.nestedUnkeyedContainer(forKey: key)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return NestedSingleValueDecodingContainer(container: container, key: key)
    }
}
