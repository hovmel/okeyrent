//
//  APIService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation

class APIService :  NSObject {
    
//    var sessionManager = Session()
//    let jsonDecoder = JSONDecoder()
//    
//    private let sourcesURL = URL(string: "http://api.apsdev.ru/customers/self/reg/sms-send")!
//    
//    func sendRegisterPhone(phone: String, completion : @escaping (BaseResponse) -> ()) {
//        
//        let params: Parameters = [
//            "phone": phone
//        ]
//        
//        sessionManager.request(sourcesURL, method: .post, parameters: params, headers: nil).response { [weak self] response in
//            guard let self = self else {return}
//            switch response.result {
//            case .success(let value):
//                if let value = value {
//                    do {
//                        print(String(decoding: value, as: UTF8.self))
//                        let empData = try self.jsonDecoder.decode(BaseResponse.self, from: value)
//                        completion(empData)
//                    } catch {
//                        print(String(describing: error))
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        
//    }
//    
//    func sendRegisterCode(code: String, registerModel: RegisterModel, completion : @escaping (BaseResponse) -> ()) {
//        
//        let params: Parameters = [
//            "phone": registerModel.phone,
//            "first_name": registerModel.name,
//            "second_name": registerModel.secondName,
//            "code": code,
//        ]
//        
//        sessionManager.request(sourcesURL, method: .post, parameters: params, headers: nil).response { [weak self] response in
//            guard let self = self else {return}
//            switch response.result {
//            case .success(let value):
//                if let value = value {
//                    do {
//                        print(String(decoding: value, as: UTF8.self))
//                        let empData = try self.jsonDecoder.decode(BaseResponse.self, from: value)
//                        completion(empData)
//                    } catch {
//                        print(String(describing: error))
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        
//    }
    
}

// MARK: - Welcome
struct Employees: Decodable {
    let status: String
    let data: [EmployeeData]
}

// MARK: - Datum
struct EmployeeData: Decodable {
    let id, employeeName, employeeSalary, employeeAge: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}
