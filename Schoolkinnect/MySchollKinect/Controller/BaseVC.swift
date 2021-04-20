//
//  BaseVC.swift
//  Toto
//
//  Created by Tarak on 20/01/20.
//  Copyright © 2020 Tarak. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseVC: UIViewController, NVActivityIndicatorViewable {
    var vSpinner : UIView?
    var strPhoneNumber : String = ""
//    var reachability: Reachability?
    var alertShowDuration = 3.0
//    let network: Connection = Connection.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        //        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @IBAction func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OpenSidemenu(_ button:UIButton)
    {
        let StoryBoard = UIStoryboard.init(name: "SideMenuVC", bundle: nil)
        guard let SideMenu = StoryBoard.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC else {return}
        //let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        //let RootViewController = serviceManager.RootViewController
        SideMenu.modalPresentationStyle = .custom
        SideMenu.currentVC = self
        SideMenu.view.frame = CGRect(x: 0, y: 0, width: SideMenu.view.bounds.width, height: SideMenu.view.bounds.height)//(width: SideMenu.view.bounds.width, height: SideMenu.view.bounds.height - 150)
        let Delegate = siemenuDelegate.init()
        SideMenu.transitioningDelegate = Delegate
        self.present(SideMenu, animated: true, completion: nil)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activityIndicatorView = NVActivityIndicatorView(frame: spinnerView.frame, type: NVActivityIndicatorType.lineScale)
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballScaleMultiple, fadeInAnimation: nil)
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicatorView)
            onView.addSubview(spinnerView)
        }
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            //            onView.removeFromSuperview()
            self.stopAnimating(nil)
            //            self.vSpinner?.superview!.removeFromSuperview()
            self.vSpinner?.removeFromSuperview()
            
            self.vSpinner = nil
        }
    }
}
