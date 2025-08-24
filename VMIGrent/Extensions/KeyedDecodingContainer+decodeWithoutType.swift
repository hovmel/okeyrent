//
//  PrimitiveSequense+map+customDecoder.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    public func decode<T: Decodable>(_ key: Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T: Decodable>(_ key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
