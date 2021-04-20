//
//  UIAlertController.swift
//  CLM
//
//  Created by DEVIL DECODER on 18/08/18.
//  Copyright © 2018 DECODER. All rights reserved.
//

import UIKit
import Foundation
extension UIAlertController{
    
    
    func Simplealert(withTitle title:String,Message:String,presentOn:UIViewController)
    {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        presentOn.present(alert, animated: true, completion: nil)
    }
    
    func ServerError(PresentOn viewController:UIViewController){
        let alert = UIAlertController.init(title: "OOPS! Server Error!", message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func retry(PresentOn viewController:UIViewController,withRetry retry:@escaping ()->())
    {
        let alert = UIAlertController.init(title: "OOPS! Server Unreachable!", message: "", preferredStyle: .alert)
        let Cancelaction = UIAlertAction.init(title: "Cancel", style: .cancel)
        let retryAction = UIAlertAction.init(title: "Retry", style: .default) { (action) in
            retry()
        }
        alert.addAction(Cancelaction)
        alert.addAction(retryAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func NoInternet(PresentOn viewController:UIViewController)
    {
        let alert = UIAlertController.init(title: "No Internet!", message: "Please turn on internet connection", preferredStyle: .alert)
        let Cancelaction = UIAlertAction.init(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            let app = UIApplication.shared.delegate as! UIApplication
//            if app.canOpenURL(URL.init(string: UIApplication.openSettingsURLString)!)
//            {
//                app.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//            }
        }
        alert.addAction(Cancelaction)
        alert.addAction(settingsAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    func simpleMessageWithSingleAction(action:(()->())?,title:String,message:String,presentOn view:UIViewController)
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
            guard let performAction = action else{return}
            performAction()
        }
        alert.addAction(actionOK)
        view.present(alert, animated: true, completion: nil)
    }

    
}
