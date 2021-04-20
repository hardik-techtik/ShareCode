//
//  TermsOfUseVC.swift
//  MySchollKinect
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit

class TermsOfUseVC: BaseVC {
    
    @IBOutlet weak var bckView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSchoolAgreemant: UITextView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //btnBack.addTarget(self, action: #selector(Back), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(Next), for: .touchUpInside)
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.Termsofuse()
    }
    @objc func Back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Next() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVc") as? PrivacyPolicyVc  else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.bckView.AddDefaultShadow()
    }
}
//MARK:- services
extension TermsOfUseVC {
    func Termsofuse() {
        let serviceManager = ServiceManager<UserPages>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "page"
        serviceManager.Parameters = ["slug":"user-agreement"]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let UserPage = Response as? ResponseModelDic<UserPages>
            let font = UIFont(name: "SFProDisplay-Regular", size: 16)
            let strHTML = "<head><meta content='width=device-width, initial-scale=3.0, maximum-scale=1.0, user-scalable=0' name='viewport' /></head><span style=\"font-family:\(font!.fontName); font-size:\(font!.pointSize) !important; color:rgba(102, 102, 102, 1)\">\(UserPage?.Data?.content ?? "Something went wrong.")</span>"
            self.webView.loadHTMLString(strHTML, baseURL: nil)
            /*guard let data = (UserPage?.Data?.last?.content ?? "").data(using: String.Encoding.utf8) else {return}
            do {
                self.txtSchoolAgreemant.attributedText = try NSAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                print(error)
            }*/
        }
    }
}
