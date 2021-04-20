//
//  BackButton.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    private var rootView:UINavigationController?
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(Back(_:)), for: .touchUpInside)
    }

    @objc func Back(_ button:UIButton)
    {
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        self.rootView = serviceManager.RootViewController as? UINavigationController
        self.rootView?.popViewController(animated: true)
    }
}
