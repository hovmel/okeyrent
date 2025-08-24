//
//  CustomerModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation
import UIKit

enum DocumentState: String, Decodable {
    case notLoaded = "NOT_LOADED"
    case moderation = "MODERATION"
    case accepted = "ACCEPTED"
    case declined = "DECLINED"
    
    var textColor: UIColor {
        switch self {
        case .notLoaded, .declined:
            return Colors.redAttention
        case .moderation:
            return Colors.attention
        case .accepted:
            return Colors.main
        }
    }
    
    var color: UIColor {
        switch self {
        case .notLoaded, .declined:
            return Colors.lightRed
        case .moderation:
            return Colors.F3EBDA
        case .accepted:
            return Colors.lightGreen
        }
    }
}

class CustomerModel: BaseResponse {
    
    var id: Int? = 0
    var createdAt: Int? = 0
    var name: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var middleName: String?
    var birthDate: String?
    var email: String?
    var phone: String? = ""
    var picture: PictureModel?
    var timeZone: Int?
    var documentStateId: DocumentState? = .notLoaded
    var documentState: DocumentStateModel? = DocumentStateModel()
    var documentDeclineReason: String?
    var documentPhoto: PictureModel?
    var photoWithDocument: PictureModel?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(.id)
        createdAt = try container.decodeIfPresent(.createdAt)
        name = try container.decodeIfPresent(.name)
        firstName = try container.decodeIfPresent(.firstName)
        lastName = try container.decodeIfPresent(.lastName)
        middleName = try container.decodeIfPresent(.middleName)
        email = try container.decodeIfPresent(.email)
        phone = try container.decodeIfPresent(.phone)
        picture = try container.decodeIfPresent(.picture)
        birthDate = try container.decodeIfPresent(.birthDate)
        timeZone = try container.decodeIfPresent(.timeZone)
        documentStateId = try container.decodeIfPresent(.documentStateId)
        documentState = try container.decodeIfPresent(.documentState)
        documentDeclineReason = try container.decodeIfPresent(.documentDeclineReason)
        documentPhoto = try container.decodeIfPresent(.documentPhoto)
        photoWithDocument = try container.decodeIfPresent(.photoWithDocument)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case email
        case phone
        case picture
        case timeZone
        case documentStateId = "document_state_id"
        case documentState = "document_state"
        case documentDeclineReason = "document_decline_reason"
        case documentPhoto = "document_photo"
        case photoWithDocument = "photo_with_document"
        case birthDate = "birth_date"
    }
    
    var templateProfile: TemplateProfile {
        return TemplateProfile(name: self.firstName,
                               lastName: self.lastName,
                               birthday: self.birthDate,
                               email: nil,
                               photo: nil,
                               photoString: self.picture?.original)
    }
    
    override init() {
        super.init()
    }

    
}

struct DocumentStateModel: Decodable {
    var id: DocumentState = .notLoaded
    var title: String = ""
}
