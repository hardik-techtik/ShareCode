//
//  ThankYouVC.swift
//  MySchollKinect
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ThankYouVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var btnFinish: CornerButton!
    
    var selectedschool:Schools?
    var tplSchoolDetail : (String?, String?, String?)
    var isFromMyAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        backButton.addTarget(self, action: #selector(Back), for: .touchUpInside)
        btnFinish.addTarget(self, action: #selector(Finish), for: .touchUpInside)
    }
    @objc func Finish() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeCollegeVC") as? WelcomeCollegeVC else { return }
        vc.selectedschool = self.selectedschool
        vc.tplSchoolDetail = tplSchoolDetail
        vc.isFromMyAccount = self.isFromMyAccount
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func Back() {
        //self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.BackView.AddDefaultShadow()
    }
}




    

