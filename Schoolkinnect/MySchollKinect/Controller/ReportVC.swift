//
//  ReportVC.swift
//  MySchollKinect
//
//  Created by Admin on 02/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReportVC: BaseVC {

    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnReport: CornerButton!
    var ReportID = 0
    var userId = 0
    var For = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReport.addTarget(self, action: #selector(Report(_:)), for: .touchUpInside)
    }
    
    @objc func Report(_ button:UIButton) {
        if (txtMessage.text != "") {
            self.SubmitReport()
        } else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please write your issue",onVc:self)
        }
    }
    
    @IBAction func buttonClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- webservice
extension ReportVC {
    func SubmitReport() {
        var strKeyName = String()
        if For == "poll" {
            strKeyName = "poll_id"
        }
        else if For == "post" {
            strKeyName = "post_id"
        }
        else if For == "event" {
            strKeyName = "event_id"
        }
        else if For == "video" {
            strKeyName = "share_video"
        }
        
        let serviceManager = ServiceManager<Posts>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "report"
        serviceManager.Parameters = [
            "to_user_id":userId,
            "\(strKeyName)":self.ReportID,
            "reason":self.txtMessage.text ?? "",
            "type":For]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            self.navigationController?.popViewController(animated: true)
            RDalertcontoller().presentAlertWithMessage(Message:"\(self.For.capitalized) reported successfully",onVc:self)
        }
    }
}
/*extension ReportVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtMessage {
            if (textView.text == "Please write your issue" && textView.textColor == .lightGray) {
                textView.text = ""
                textView.textColor = .black
            }
        }
        textView.becomeFirstResponder() //Optional
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == txtMessage {
            if textView.text.isEmpty {
                txtMessage.text = "Please write your issue"
                txtMessage.textColor = .lightGray
            }
        }
    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        let numberOfChars = newText.count
//        if textView == txtMessage {
//            self.objLblFeedbackCharacterCount.text = "\(numberOfChars)/250"
//            intTellAboutTaskCount = numberOfChars
//            return numberOfChars < 300
//        } else {
//        }
//        return true
//    }
}*/
