//
//  PrivateMessageVC.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PrivateMessageVC: UIViewController {


    @IBOutlet weak var BackView: UIView!
    var strUserProfile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BackView.AddDefaultShadow()
    }


}
