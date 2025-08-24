//
//  ProfileServoce.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation
import RxSwift
import Moya

class ProfileService {
    
    var provider: MoyaProvider<ProfileAPI> = MoyaProvider<ProfileAPI>(plugins: moyaPlugins)
    
    func getProfile() -> Observable<CustomerModel> {
        return provider.rx.request(.getProfile,
                                   callbackQueue: DispatchQueue.main)
            .decode(CustomerModel.self)
    }
    
    func getCommon() -> Observable<CommonResponse> {
        return provider.rx.request(.getCommon,
                                   callbackQueue: DispatchQueue.main)
            .decode(CommonResponse.self)
    }
    
    func updateProfile(profile: TemplateProfile) -> Observable<CustomerModel> {
        return provider.rx.request(.updateProfile(profile.name, profile.lastName, profile.birthday, profile.email, profile.photo),
                                   callbackQueue: DispatchQueue.main)
            .decode(CustomerModel.self)
    }
    
    func sendNewPhone(phone: String) -> Observable<BaseResponse> {
        return provider.rx.request(.sendNewPhone(phone),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func sendNewCode(phone: String, code: String) -> Observable<BaseResponse> {
        return provider.rx.request(.sendNewCode(phone, code),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func sendDocuments(id: Int, passport: UIImage, selfie: UIImage) -> Observable<CustomerModel> {
        return provider.rx.request(.sendDocuments(id, passport, selfie),
                                   callbackQueue: DispatchQueue.main)
            .decode(CustomerModel.self)
    }
    
    func getFeatures() -> Observable<[FeatureModel]> {
        return provider.rx.request(.getFeatures,
                                   callbackQueue: DispatchQueue.main)
            .decode([FeatureModel].self)
    }
    
    func logout() -> Observable<BaseResponse> {
        return provider.rx.request(.logout,
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func delete() -> Observable<BaseResponse> {
        return provider.rx.request(.delete,
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }

}
