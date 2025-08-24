//
//  PrimitiveSequense+map+customDecoder.swift
//  GLC
//
//  Created by Михаил on 18.10.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import Foundation
import RxSwift
import Moya

fileprivate let customDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .custom({ (key) -> DateFormatter? in
//        switch key {
//        default:
//            return DateFormatter.full
//        }
//    })
    return decoder
}()

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapWithCustomDecoder<D: Decodable>(_ type: D.Type) -> Single<D> {
        return map(type, atKeyPath: nil, using: customDecoder, failsOnEmptyData: true)
    }
    
    public func decode<D: Decodable>(_ type: D.Type) -> Observable<D> {
        return map(type, atKeyPath: nil, using: customDecoder, failsOnEmptyData: true).asObservable()
    }
    
}
