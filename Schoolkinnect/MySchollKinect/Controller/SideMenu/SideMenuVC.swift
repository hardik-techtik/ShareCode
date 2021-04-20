//
//  SideMenuVC.swift
//  MySchollKinect
//
//  Created by Admin on 29/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnCloseTools: UIButton!
    @IBOutlet weak var tablViewHeight: NSLayoutConstraint!
    
    var currentVC : UIViewController?
    
    let MenuName = ["Home","My Profile","Settings","Contacts","Help","Member Search","Share","Logout"]
    
    let MenuImage = [UIImage.init(named: "home"),UIImage.init(named: "MyProfile"),UIImage.init(named: "Settings"),UIImage.init(named: "Contacts"),UIImage.init(named: "question-circle"),UIImage.init(named: "Serch Blue"),UIImage.init(named: "share-it"),UIImage.init(named: "logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.dataSource = self
        self.tblView.delegate = self
        
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(CloseTools(_:)))
        swipe.direction = .up
        swipe.delegate = self
        self.tblView.addGestureRecognizer(swipe)
        
        self.view.addGestureRecognizer(swipe)
        
        self.btnCloseTools.addTarget(self, action: #selector(CloseTools(_:)), for: .touchUpInside)
        
        let View = UIView()
        View.backgroundColor = UIColor.init(hexFromString: "000000", alpha: 0.2)
        self.tblView.tableFooterView = View
        view.addGestureRecognizer(swipe)
        view.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblView.clipsToBounds = true
        tblView.layer.cornerRadius = 15
        tblView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        //let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(closemenu(:)))
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = -(self.view.frame.height)
        }) { (completed) in
            super.dismiss(animated: flag, completion: completion)
        }
    }
    @objc func CloseTools(_ button:UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}



extension SideMenuVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MenuName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsCell") as? ToolsCell
        cell?.lblToolsName.text = self.MenuName[indexPath.row]
        cell?.imgeTools.image = self.MenuImage[indexPath.row]?.withRenderingMode(.alwaysTemplate)
        cell?.imgeTools.tintColor = UIColor(hexFromString: "133461")//UIColor.init(hex: "133461")
        self.view.layoutIfNeeded()
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        switch indexPath.row {
        case 0:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC else {return}
            VC?.show(vc, sender: nil)
        case 1:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileVC else {return}
            VC?.show(vc, sender: nil)
        case 2:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC else {return}
            VC?.show(vc, sender: nil)
        case 3:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "MyContactsVC") as? MyContactsVC else {return}
            VC?.show(vc, sender: nil)
        case 4:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "HelpCenterVC") as? HelpCenterVC else {return}
            VC?.show(vc, sender: nil)
        case 5:
            self.dismiss(animated: false, completion: nil)
            let VC = self.presentingViewController as? UINavigationController
            guard let vc = StoryBoard.instantiateViewController(withIdentifier: "MemberSearchVC") as? MemberSearchVC else {return}
            VC?.show(vc, sender: nil)
        case 6:
            //self.dismiss(animated: false, completion: nil)
            self.perform(#selector(share), with: nil, afterDelay: 1.0)
            break
        case 7:
            
            let alert = UIAlertController.init(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
            let yes = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                self.dismiss(animated: false, completion: nil)
                let VC = self.presentingViewController as? UINavigationController
                guard let vc = StoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as? GetStartedVC else {return}
                UserDefaults.standard.removeObject(forKey: "User")
                UserDefaults.standard.removeObject(forKey: "SchoolName")
                UserDefaults.standard.removeObject(forKey: "isSocialLogin")
                VC?.setViewControllers([vc], animated: true)
                //self.currentVC?.navigationController?.popToRootViewController(animated: true)
            }
            let No = UIAlertAction.init(title: "No", style: .default){
                (sction) in
                self.dismiss(animated: true)
            }
            alert.addAction(yes)
            alert.addAction(No)
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    @objc func share() {
        
        
        let socialProvider = ShareTextImageAndUlrWithSpacificApp(img: UIImage(), url: URL(string: "http://www.google.com")! , title: String())
        let activityViewController = UIActivityViewController(activityItems: [socialProvider], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                  while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                       }
                topController.dismiss(animated: true, completion: nil)
            }

            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//Mark:- swipegesture
extension SideMenuVC:UIGestureRecognizerDelegate
{
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
