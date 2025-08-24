//
//  LoadController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation
import UIKit
import RxSwift

class LoadController: UIViewController {
    
    var service: ProfileService = ProfileService()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDefinitions()
    }
    
    private func getDefinitions() {
        self.service.getCommon().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                DefinitionManager.shared.objectsFeaturesTypeDefinition = response.objectsFeaturesTypeDefinition
                DefinitionManager.shared.objectsTypeDefinition = response.objectsTypeDefinition
                DefinitionManager.shared.objectsObjectBedsTypeDefinition = response.objectsObjectBedsTypeDefinition
                DefinitionManager.shared.bookingTypes = response.bookingsStateDefinition
                DefinitionManager.shared.contactPhone = response.contactPhone ?? ""
                DefinitionManager.shared.contactEmail = response.contactEmail ?? ""
                DefinitionManager.shared.userAgreement = response.userAgreement ?? ""
                DefinitionManager.shared.privacyPolicy = response.privacyPolicy ?? ""
                self.getFeatures()
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func getFeatures() {
        self.service.getFeatures().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                DefinitionManager.shared.features = response
                let sb = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = sb
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}
