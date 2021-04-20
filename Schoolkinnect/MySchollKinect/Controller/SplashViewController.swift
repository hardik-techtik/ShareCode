//
//  SplashViewController.swift
//  MySchollKinect
//
//  Created by Pritesh on 19/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let serviceManager = ServiceManager<ResponseModelSuccess>.init()
    private(set) var rootView : UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let token = UserDefaults.standard.object(forKey: "logintoken") as? String
        let authToken = (token == nil || token == "") ? "" : token ?? ""
        print("authToken-----\(authToken)")
        self.perform(#selector(redirectToGetStartedOrHome), with: nil, afterDelay: 5)
    }
    @objc func redirectToGetStartedOrHome() {
        let serviceManager = ServiceManager<ResponseModelSuccess>()
        let rootView = serviceManager.RootViewController as? UINavigationController
        self.rootView = rootView
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let user = UserDefaults.standard.data(forKey: "User") {
            do {
                let Tempuser = try JSONDecoder().decode(User.self, from: user)
                User.shared = Tempuser
                print(User.shared)
                if User.shared.schoolID != nil && User.shared.id != nil  && (User.shared.isVerifiedOtp != nil && (User.shared.isVerifiedOtp ?? "") == "1") {
                    serviceManager.DismissProgress()
                    let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC
                    //                    rootView?.setViewControllers([vc], animated: false)
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    serviceManager.DismissProgress()
                    let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC
                    //                    rootView?.setViewControllers([vc], animated: false)
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                
            } catch  {
                serviceManager.DismissProgress()
                let Error = error as? DecodingError
                print(Error?.failureReason ?? "")
            }
        }
        else{
            serviceManager.DismissProgress()
            let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC
            //           rootView?.setViewControllers([vc], animated: false)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
