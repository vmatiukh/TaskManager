//
//  Updatable.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/6/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//
//

import Foundation

protocol DecoderUpdatable {
    mutating func update(from decoder: Decoder) throws
}

protocol DecodingFormat {
    func decoder(for data: Data) -> Decoder
}

extension DecodingFormat {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try T.init(from: decoder(for: data))
    }
    func update<T: DecoderUpdatable>(_ value: inout T, from data: Data) throws {
        try value.update(from: decoder(for: data))
    }
}

struct DecoderExtractor: Decodable {
    let decoder: Decoder
    
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}

extension JSONDecoder: DecodingFormat {
    func decoder(for data: Data) -> Decoder {
        // Can try! here because DecoderExtractor's init(from: Decoder) never throws
        return try! decode(DecoderExtractor.self, from: data).decoder
    }
}

extension PropertyListDecoder: DecodingFormat {
    func decoder(for data: Data) -> Decoder {
        // Can try! here because DecoderExtractor's init(from: Decoder) never throws
        return try! decode(DecoderExtractor.self, from: data).decoder
    }
}

extension KeyedDecodingContainer {
    func update<T: DecoderUpdatable>(_ value: inout T, forKey key: Key, userInfo: [CodingUserInfoKey : Any] = [:]) throws {
        let nestedDecoder = NestedDecoder(from: self, key: key, userInfo: userInfo)
        try value.update(from: nestedDecoder)
    }
}
