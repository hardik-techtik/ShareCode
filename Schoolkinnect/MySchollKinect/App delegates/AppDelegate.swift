//
//  AppDelegate.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GooglePlaces
import GoogleMaps
import IQDropDownTextField
import UserNotifications
import CoreLocation
import Contacts
import AddressBook
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    enum LoggedIn {
        case Facebook
        case Apple
        case Simple
    }
    
    var LoggedinWith:LoggedIn = .Simple
    
    var window: UIWindow?
    private let serviceManager = ServiceManager<ResponseModelSuccess>.init()
    private(set) var rootView : UINavigationController?
    
    let locationMgr = CLLocationManager()
    
    var latitute : Double = 0.0
    var longtitute : Double = 0.0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 3.0))
        
        
        // App version 1.6 commit build 1 
        
        sleep(3)
        self.registerForPushNotifications(application: application)
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        UserDefaults.standard.set(true, forKey: "contactEnable")
        //self.registrContactPermission()
        //You need to provide contact access to link and manage contacts.
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //GMSPlacesClient.uuØ("AIzaSyC0RqLa90WDfoJedoE3Z_Gy7a7o8PCL2jw")
        //GMSServices.provideAPIKey("AIzaSyCVtMdeqd3tmEO6-hZ-4daAtvMX72_VWKw")
        
        let loginUserID = UserDefaults.standard.object(forKey: "loginUserID") as? Int
        print("loginUserID-----\(loginUserID ?? 0)")
        User.shared.id =  (loginUserID == nil || loginUserID == 0) ? 0 : loginUserID ?? 0
        
        //SocketHelper.shared.connect()
        let token = UserDefaults.standard.object(forKey: "logintoken") as? String
        
        let authToken = (token == nil || token == "") ? "" : token ?? ""
        print("authToken-----\(authToken)")
        
        //       if CLLocationManager.locationServicesEnabled() {
        //             switch CLLocationManager.authorizationStatus() {
        //                case .notDetermined, .restricted, .denied:
        //                    print("No access")
        //                UserDefaults.standard.set(false, forKey: "locationEnable")
        //                case .authorizedAlways, .authorizedWhenInUse:
        //                    print("Access")
        //                UserDefaults.standard.set(true, forKey: "locationEnable")
        //             @unknown default:
        //                fatalError()
        //        }
        //            } else {
        //                print("Location services are not enabled")
        //        UserDefaults.standard.set(false, forKey: "locationEnable")
        //        }
        //        UserDefaults.standard.synchronize()
        
        //        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
        //            if (granted){
        //                 //
        //                print("granted  in contact")
        //                UserDefaults.standard.set(true, forKey: "contactEnable")
        //            } else {
        //                UserDefaults.standard.set(false, forKey: "contactEnable")
        //                print("errorrrrrr in contact")
        //            }
        //        })
        //        return true
        //MARK:-FIREBASE SETUO
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func registrContactPermission() {
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (granted){
                UserDefaults.standard.set(true, forKey: "contactEnable")
            } else {
                UserDefaults.standard.set(false, forKey: "contactEnable")
            }
        })
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        //        if #available(iOS 10.0, *) {
        //            // For iOS 10 display notification (sent via APNS)
        //            UNUserNotificationCenter.current().delegate = self
        //            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        //            UNUserNotificationCenter.current().requestAuthorization(
        //                options: authOptions,
        //                completionHandler: {_, _ in })
        //            // For iOS 10 data message (sent via FCM
        //            //            Messaging.messaging().remoteMessageDelegate = self
        //        } else {
        //            let settings: UIUserNotificationSettings =
        //                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //        }
        //
        //        //        application.registerUserNotificationSettings(pushNotificationSettings)
        //
        //        application.registerForRemoteNotifications()
        
        if #available(iOS 10, *) { // iOS 10 support
            //create the notificationCenter
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            // set the type as sound or badge
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                    UserDefaults.standard.set(true, forKey: "notificationEnable")
                }else{
                    print("Some Error Occure")
                    UserDefaults.standard.set(false, forKey: "notificationEnable")
                }
                UserDefaults.standard.synchronize()
            }
            application.registerForRemoteNotifications()
        } else if #available(iOS 9, *) {
            // iOS 9 support
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        } else if #available(iOS 8, *) {
            // iOS 8 support
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound,
                                                                                                     .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        } else { // iOS 7 support
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        
    }
    
    //get error here
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error:
                        Error) {
        print("Registration failed!")
    }
    
    //get Notification Here below ios 10
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received: \(data)")
//
//    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.rootView?.dismiss(animated: true, completion: nil)
    }
    
    //This is the two delegate method to get the notification in iOS 10..
    //First for foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options:UNNotificationPresentationOptions) -> Void)
    {
        print("Handle push from foreground")
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
    }
    //Second for background and close
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
    
    // 1
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            //            print("Current location: \(currentLocation)")
        }
        
        self.latitute = locations.last?.coordinate.latitude ?? 0.0
        self.longtitute = locations.last?.coordinate.longitude ?? 0.0
        
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
       
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")

        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
  
}


