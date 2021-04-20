//
//  PrivacyPolicyVc.swift
//  MySchollKinect
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVc: BaseVC {
    
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var txtPrivacyPolicy: UITextView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnnext.addTarget(self, action: #selector(Next), for: .touchUpInside)
//        BackView.AddDefaultShadow()
        PrivacyPolicy()
    }
    
    @objc func Next() { }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func buttonClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PrivacyPolicyVc {
    func PrivacyPolicy() {
        let serviceManager = ServiceManager<UserPages>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "page"
        serviceManager.Parameters = ["slug":"pravicy-policy"]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            print(Response)
            let UserPage = Response as? ResponseModelDic<UserPages>
            //self.webView.loadHTMLString(UserPage?.Data?.last?.content ?? "Something went wrong.", baseURL: nil)
            let font = UIFont(name: "SFProDisplay-Regular", size: 16)
            let strHTML = "<head><meta content='width=device-width, initial-scale=3.0, maximum-scale=1.0, user-scalable=0' name='viewport' /></head><span style=\"font-family:\(font!.fontName); font-size:\(font!.pointSize) !important; color:rgba(102, 102, 102, 1)\">\(UserPage?.Data?.content ?? "Something went wrong.")</span>"
            self.webView.loadHTMLString(strHTML, baseURL: nil)
            
            
            
//            self.webView.load(URLRequest(url: URL(string: "http://www.myschoolkinect.com/privacy-policy/")!))
            
//            guard let data = (UserPage?.Data?.last?.content ?? "").data(using: String.Encoding.utf8) else {return}
//            do {
//
//                //self.txtPrivacyPolicy.attributedText = try NSAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//            }
//            catch {
//                print(error)
//            }
        }
    }
}
