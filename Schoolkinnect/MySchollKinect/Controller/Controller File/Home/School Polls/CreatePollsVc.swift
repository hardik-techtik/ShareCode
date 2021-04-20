//
//  CreatePollsVc.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GrowingTextView

protocol PollsDelegate:class {
    func pollDidCreated()
}

class CreatePollsVc: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnSubmit: CornerButton!
    @IBOutlet weak var lblTIile: UILabel!
    @IBOutlet weak var lblCreatePolls: UILabel!

    var Updating = false
    var PostID = ""
    
    weak var Delegate:PollsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //txtDescription.delegate = self
        btnSubmit.addTarget(self, action: #selector(Submit(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
////        print("-----")
//            if !self.txtDescription.text.isEmpty {
//                lblCreatePolls.text = " Update a poll "
//            } else {
//                lblCreatePolls.text = " Create a new poll "
//            }
    }
    
    @objc func Submit(_ button:UIButton) {
        if !self.txtDescription.text.isEmpty {
            if self.Updating {
                self.UpdatePolls(PollsID: self.PostID)
            } else {
                self.CreatePolls()
            }
        } else {
             RDalertcontoller().presentAlertWithMessage(Message:" Please add poll description ",onVc:self)
        }
    }
}
extension CreatePollsVc:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textview = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if textview.count > 0 {
            for view in textView.subviews {
                if view.tag == 1 {
                    view.isHidden = true
                }
            }
        } else {
            for view in textView.subviews {
                if view.tag == 1 {
                    view.isHidden = false
                }
            }
        }
        return true
    }
}

//MARK:- WebService
extension CreatePollsVc {
    func CreatePolls() {
        let serviceManager = ServiceManager<PollCreated>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll"
        serviceManager.Parameters = [
            "description": self.txtDescription.text ?? "",
            "school_id" : User.shared.schoolID ?? 0
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Polls = Response as? ResponseModelDic<PollCreated>
            print(Polls!)
            self.txtDescription.text = nil
            RDalertcontoller().presentAlertWithMessage(Message:"Poll has been added successfully.",onVc:self)
            self.Delegate?.pollDidCreated()
        }
    }
    func UpdatePolls(PollsID:String) {
        let serviceManager = ServiceManager<PollCreated>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll/\(PollsID)"
        serviceManager.Parameters = [
            "description": self.txtDescription.text ?? ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .put) { (Response) in
            let Polls = Response as? ResponseModelDic<PollCreated>
            print(Polls!)
            self.txtDescription.text = nil
            self.Updating = false
            RDalertcontoller().presentAlertWithMessage(Message:"Poll update sucessfully",onVc:self)
            self.Delegate?.pollDidCreated()
        }
    }
}
