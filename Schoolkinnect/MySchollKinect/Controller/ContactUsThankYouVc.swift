//
//  ContactUsThankYouVc.swift
//  MySchollKinect
//
//  Created by Shreyansh on 19/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ContactUsThankYouVc: BaseVC {
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.AddDefaultShadow()
        
        RDalertcontoller().presentAlertWithMessage(Message: "Mail sent successfully",onVc:self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
