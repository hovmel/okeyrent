//
//  RegisterService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import Foundation
import RxSwift
import Moya

class RegisterService {
    
    var provider: MoyaProvider<RegisterAPI> = MoyaProvider<RegisterAPI>(plugins: moyaPlugins)
    
    func registerPhone(code: String, registerModel: RegisterModel) -> Observable<AuthResponse> {
        print("request fetchToken")
        return provider.rx.request(.registerPhone(code,
                                                  registerModel.phone,
                                                  registerModel.name,
                                                  registerModel.secondName),
                                   callbackQueue: DispatchQueue.main)
            .decode(AuthResponse.self)
    }
    
    func sendPhone(phone: String) -> Observable<BaseResponse> {
        print("request fetchToken")
        return provider.rx.request(.sendPhone(phone),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func registerDevice(token: String, model: String, os: String) -> Observable<Response> {
        print("request fetchToken")
        return provider.rx.request(.registerDevice(token, model, os),
                                   callbackQueue: DispatchQueue.main)
            .asObservable()
    }

}


import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        return flatMap { response -> Single<T> in
            do {
                let object = try decoder.decode(T.self, from: response.data)
                return .just(object)
            } catch {
                return .error(error)
            }
        }
        .asObservable()
    }
}
