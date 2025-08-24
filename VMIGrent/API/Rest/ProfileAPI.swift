//
//  ProfileAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Moya
import UIKit

enum ProfileAPI: BaseAPI {
    case getProfile
    case updateProfile(String?, String?, String?, String?, UIImage?)
    case getCommon
    case sendNewPhone(String)
    case sendNewCode(String, String)
    case sendDocuments(Int, UIImage, UIImage)
    case getFeatures
    case logout
    case delete
}

extension ProfileAPI: TargetType {
    
    var path: String {
        switch self {
        case .getProfile:
            return "/customers/self/detail"
        case .updateProfile:
            return "/customers/self/update-profile"
        case .getCommon:
            return "/common/definitions"
        case .sendNewPhone:
            return "/customers/self/update-phone/sms-send"
        case .sendNewCode:
            return "/customers/self/update-phone/sms-check"
        case .sendDocuments:
            return "/customers/self/update-documents"
        case .getFeatures:
            return "/objects/features/list"
        case .logout:
            return "/customers/self/logout"
        case .delete:
            return "/customers/self/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfile, .getCommon, .getFeatures:
            return .get
        case .updateProfile, .sendNewCode, .sendNewPhone, .sendDocuments, .logout, .delete:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .logout, .delete:
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        case .sendNewCode(let phone, let code):
            let params: [String: Any] = ["phone":phone,
                                         "code":code]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .sendNewPhone(let phone):
            let params: [String: Any] = ["phone":phone]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getProfile, .getCommon, .getFeatures:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .updateProfile(let first_name, let last_name, let birth_date, let email, let picture):
            var params: [String: Any] = [:]
            if let first_name = first_name {
                params["first_name"] = first_name
            }
            if let last_name = last_name {
                params["last_name"] = last_name
            }
            if let birth_date = birth_date {
                params["birth_date"] = birth_date
            }
            if let email = email {
                params["email"] = email
            }
            if let picture = picture {
                var formData: [Moya.MultipartFormData] = []
                let imageData = picture.fixedOrientation().jpegData(compressionQuality: 0.5)
                let imageDataT = MultipartFormData(provider: .data(imageData!), name: "picture", fileName: "profile.jpg", mimeType: "image/jpeg")
                formData.append(imageDataT)
                return .uploadCompositeMultipart(formData, urlParameters: params)
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .sendDocuments(let id, let passport, let selfie):
            let params: [String: Any] = ["id":id]
            var formData: [Moya.MultipartFormData] = []
            let passportData = passport.fixedOrientation().jpegData(compressionQuality: 0.5)
            let passportDataT = MultipartFormData(provider: .data(passportData!), name: "document_photo", fileName: "document_photo.jpg", mimeType: "image/jpeg")
            let selfieData = selfie.fixedOrientation().jpegData(compressionQuality: 0.5)
            let selfieDataT = MultipartFormData(provider: .data(selfieData!), name: "photo_with_document", fileName: "document_photo.jpg", mimeType: "image/jpeg")
            formData.append(passportDataT)
            formData.append(selfieDataT)
            return .uploadCompositeMultipart(formData, urlParameters: params)
        }
    }
}
