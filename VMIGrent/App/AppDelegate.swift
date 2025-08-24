//
//  AppDelegate.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.05.2022.
//

import UIKit
import YandexMapsMobile
import FirebaseMessaging
import Firebase
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupSettings(application)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        UINavigationBar.appearance().tintColor = Colors.mainBlack
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back_arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back_arrow")
        
        return true
    }
    
    private func setupSettings(_ application: UIApplication) {
        FirebaseApp.configure()
        YMKMapKit.setApiKey("81124758-0409-42c9-af95-e45492b72f16")
        YMKMapKit.sharedInstance()
        
        AirbnkSDK.init()
        self.setupNotificationSettings(application)
    }
    
    private func setupNotificationSettings(_ application: UIApplication) {
        Messaging.messaging().delegate = self
//        Messaging.messaging().sho = true
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                            self.checkAppSession()
                        }
                    }
                }
            default:
                break
            }
        }
    }

}

// MARK: Push

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func checkAppSession() {
        guard AuthManager.shared.authComplete() else {return}
        let service = RegisterService()
        service.registerDevice(token: Messaging.messaging().fcmToken ?? "",
                               model: UIDevice.modelName,
                               os: UIDevice.current.systemVersion).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                return
            case .error(_):
                return
            }
        }.disposed(by: disposeBag)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
        checkAppSession()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
        checkAppSession()
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: \(fcmToken)")
        checkAppSession()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        checkAppSession()
    }
    
    //Called when a notification is delivered to a foreground app.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.sound, .alert, .badge])
    }

    //Called to let your app know which action was selected by the user for a given notification.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response.notification.request.content.userInfo)
//        if let event = response.notification.request.content.userInfo["gcm.notification.event"] as? String {
//            if event == "CHAT_MESSAGE" {
////                if let controller = UIApplication.topViewController(), !controller.isKind(of: ChatViewController.self) {
////                    if let baseController = controller as? BaseController {
////                        baseController.openChatDirectly(delegate: baseController)
////                    } else {
////                        controller.openChatDirectly(delegate: nil)
////                    }
////                }
//            }
//        }
//        completionHandler()
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
//        self.didReceiveRemoteNotification(userInfo: userInfo)
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
////        if let controller = UIApplication.topViewController(), !controller.isKind(of: ChatViewController.self) {
////            if let event = notification.request.content.userInfo["gcm.notification.event"] as? String {
////                if event == "CHAT_MESSAGE" {
////                    AppData.newMessagesCounter = String(Int(AppData.newMessagesCounter)! + 1)
////                    UIApplication.shared.applicationIconBadgeNumber = Int(AppData.newMessagesCounter)!
////                    Extras.refreshBadge(fromBackend: true)
////                }
////            }
//            completionHandler([.alert, .badge, .sound])
////        }
//    }
    
}
