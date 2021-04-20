//
//  SidemenuButton.swift
//  MySchollKinect
//
//  Created by Admin on 29/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SidemenuButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(OpenSidemenu(_:)), for: .touchUpInside)
    }

    @objc func OpenSidemenu(_ button:UIButton)
    {
        let StoryBoard = UIStoryboard.init(name: "SideMenuVC", bundle: nil)
        guard let SideMenu = StoryBoard.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC else {return}
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        let RootViewController = serviceManager.RootViewController
        SideMenu.modalPresentationStyle = .custom
        SideMenu.view.frame = CGRect(x: 0, y: 0, width: SideMenu.view.bounds.width, height: SideMenu.view.bounds.height)//(width: SideMenu.view.bounds.width, height: SideMenu.view.bounds.height - 150)
        let Delegate = siemenuDelegate.init()
        SideMenu.transitioningDelegate = Delegate
        RootViewController?.present(SideMenu, animated: true, completion: nil)
    }
}
