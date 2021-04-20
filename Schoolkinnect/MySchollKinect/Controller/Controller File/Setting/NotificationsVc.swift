//
//  NotificationsVc.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NotificationsVc: BaseVC {

    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backView.AddDefaultShadow()
    }
}
