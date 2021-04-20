//
//  GetStartedVC.swift
//  MySchollKinect
//
//  Created by Admin on 23/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreLocation

class GetStartedVC: UIViewController {

    @IBOutlet weak var btnGetstarted: UIButton!
    
    let locationMgr = CLLocationManager()
    let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGetstarted.addTarget(self, action: #selector(getStarted(_:)), for: .touchUpInside)
        self.btnGetstarted.layer.cornerRadius = self.btnGetstarted.frame.height/2
        self.btnGetstarted.layer.masksToBounds = true
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.locationManagerPermission()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.checkUserLogIn()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func getStarted(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    func locationManagerPermission() {
            let status = CLLocationManager.authorizationStatus()

            switch status {
                // 1
            case .notDetermined:
                    locationMgr.requestWhenInUseAuthorization()
                    UserDefaults.standard.set(false, forKey: "locationEnable")
                    return

                // 2
            case .denied, .restricted:
    //            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
    //            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            alert.addAction(okAction)
    //
    //            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                UserDefaults.standard.set(false, forKey: "locationEnable")
                return
            case .authorizedAlways, .authorizedWhenInUse:
                UserDefaults.standard.set(true, forKey: "locationEnable")
                locationMgr.startUpdatingLocation()
                break

            }
            UserDefaults.standard.synchronize()
            // 4
            locationMgr.delegate = self
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                self.locationMgr.startUpdatingLocation()
            }
        }
    
    func checkUserLogIn() {
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let user = UserDefaults.standard.data(forKey: "User")
        {
            
            do {
                let Tempuser = try JSONDecoder().decode(User.self, from: user)
                User.shared = Tempuser
                print(User.shared)
                if User.shared.schoolID != nil && User.shared.id != nil  /*&& (User.shared.isVerifiedOtp != nil && (User.shared.isVerifiedOtp ?? "") == "1")*/
                {
                    
                    let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreenVC
                    //guard let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return true}
                    self.navigationController?.pushViewController(vc, animated: false)
                    //rootView?.setViewControllers([vc], animated: false)
                }
                else
                {
                    //serviceManager.DismissProgress()
                    //guard let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return true}
                    //rootView?.setViewControllers([vc], animated: false)
                    UIView.transition(with: self.btnGetstarted, duration: 0.4,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.btnGetstarted.isHidden = false
                    })
                }
                
            } catch  {
                
                let Error = error as? DecodingError
                print(Error?.failureReason ?? "")
            }
        }
        else
        {
            
            UIView.transition(with: self.btnGetstarted, duration: 0.4,
                options: .transitionCrossDissolve,
                animations: {
                    self.btnGetstarted.isHidden = false
            })
            
        }
    }
    
    
    
}


extension GetStartedVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
//            print("Current location: \(currentLocation)")
        }
        
        APP_DELEGATE.latitute = locations.last?.coordinate.latitude ?? 0.0
        APP_DELEGATE.longtitute = locations.last?.coordinate.longitude ?? 0.0
        
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
