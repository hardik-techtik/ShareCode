//
//  SceneDelegate.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

@available(iOS 13.0,*)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private(set) var rootView : UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        /*let token = UserDefaults.standard.object(forKey: "logintoken") as? String
        let authToken = (token == nil || token == "") ? "" : token ?? ""
        print("authToken-----\(authToken)")
        let serviceManager = ServiceManager<ResponseModelSuccess>()
        let rootView = serviceManager.RootViewController as? UINavigationController
        self.rootView = rootView
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let user = UserDefaults.standard.data(forKey: "User")
        {
        
            
            do {
                let Tempuser = try JSONDecoder().decode(User.self, from: user)
                User.shared = Tempuser
                print(User.shared)
                if User.shared.schoolID != nil && User.shared.id != nil  && (User.shared.isVerifiedOtp != nil && (User.shared.isVerifiedOtp ?? "") == "1")
                {
                    serviceManager.DismissProgress()
                    guard let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return }
                    rootView?.setViewControllers([vc], animated: false)
                }
                else
                {
                    serviceManager.DismissProgress()
                    guard let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return }
                    rootView?.setViewControllers([vc], animated: false)
                }
                
            } catch  {
                serviceManager.DismissProgress()
                let Error = error as? DecodingError
                print(Error?.failureReason ?? "")
            }
        }
        else{
         serviceManager.DismissProgress()
           guard let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return }
           rootView?.setViewControllers([vc], animated: false)
        }*/
            
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let Context = URLContexts.first else {return}
        
        ApplicationDelegate.shared.application(UIApplication.shared, open: Context.url, sourceApplication: Context.options.sourceApplication, annotation: Context.options.annotation)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

