//
//  AuthService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation
import RxSwift
import Moya

class AuthService {
    
    var provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>(plugins: moyaPlugins)
    
    func checkPhone(code: String, phone: String) -> Observable<AuthResponse> {
        print("request fetchToken")
        return provider.rx.request(.checkPhone(code,
                                               phone),
                                   callbackQueue: DispatchQueue.main)
            .decode(AuthResponse.self)
    }
    
    func sendPhone(phone: String) -> Observable<BaseResponse> {
        print("request fetchToken")
        return provider.rx.request(.sendPhone(phone),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }

}

