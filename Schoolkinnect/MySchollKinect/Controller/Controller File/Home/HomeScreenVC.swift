//
//  HomeScreenVC.swift
//  MySchollKinect
//
//  Created by Admin on 25/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HomeScreenVC: BaseVC {
    
    @IBOutlet weak var schollpostBackView: UIView!
    @IBOutlet weak var collegename: UILabel!
    @IBOutlet weak var SchoolBackViews: UIView!
    @IBOutlet weak var MyMessageBackView: UIView!
    @IBOutlet weak var EventsBAckView: UIView!
    @IBOutlet weak var vwShareVideo: UIView!
    
    @IBOutlet weak var btnSchoolPost: UIButton!
    @IBOutlet weak var btnSchoolPolls: UIButton!
    @IBOutlet weak var btnMyMessage: UIButton!
    @IBOutlet weak var MyEvents: UIButton!
    @IBOutlet weak var objLabelUnreadCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketHelper.shared.connect()
        
        schollpostBackView.AddDefaultShadowToButton()
        SchoolBackViews.AddDefaultShadowToButton()
        MyMessageBackView.AddDefaultShadowToButton()
        EventsBAckView.AddDefaultShadowToButton()
        vwShareVideo.AddDefaultShadowToButton()
        
        self.objLabelUnreadCount.isHidden = true
        
        btnSchoolPost.addTarget(self, action: #selector(SchoolPost(_:)), for: .touchUpInside)
        btnSchoolPolls.addTarget(self, action: #selector(SchoolPolls(_:)), for: .touchUpInside)
        btnMyMessage.addTarget(self, action: #selector(MyMessages(_:)), for: .touchUpInside)
        MyEvents.addTarget(self, action: #selector(MyEvents(_:)), for: .touchUpInside)
        
        SocketHelper.shared.joinRoom(sender_id: "\(User.shared.id ?? 0)", receiver_id: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let strSchoolName : String = UserDefaults.standard.value(forKey: "SchoolName") as? String {
            self.collegename.text = strSchoolName
        }else {
            self.collegename.text = "\(User.shared.schoolusers?.last?.school?.theNameOfYourSchool ?? "")"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SocketHelper.shared.socket.emitWithAck("request_unread_count", AllUnreadMessageData.init(sender_id: User.shared.id ?? 0)).timingOut(after: 1) { data in
            print(data)
            print("request_unread_count 2....:-- ")
            let arr = data.first as? [[String: Any]]
            let dict = arr?.first?["unread_count"] as? Int
            print("data request_unread_count :-- \(dict ?? 0)")
            self.objLabelUnreadCount.text = "\(dict ?? 0)"
            if dict == 0 || dict == nil {
                self.objLabelUnreadCount.isHidden = true
            } else {
                self.objLabelUnreadCount.isHidden = false
            }
        }
        
        SocketHelper.shared.buttonClickClosureInGlobal = { (intIndex: Int) in
            print("intIndex------\(intIndex)")
            self.objLabelUnreadCount.text = "\(intIndex)"
            if intIndex == 0 {
                self.objLabelUnreadCount.isHidden = true
            } else {
                self.objLabelUnreadCount.isHidden = false
            }
        }
    }
    
    @IBAction func actionInviteFriend(_ sender: UIButton) {
        /*let activityVC = UIActivityViewController(activityItems: ["Let's bring our school together. Download My School Kinect.\nhttps://apps.apple.com/us/app/my-school-kinect/id1537795272"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.dismiss(animated: true, completion: nil)
        }*/
        
        /*let linktext = "<html><body><b>This is a bold string</b><br\\>Check out this amazing site: <a href='http://apple.com'>Apple</a></body></html>"
        
        let shareContent = [linktext]
        let activityController = UIActivityViewController(activityItems: shareContent,
                                                          applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)*/
        
        let socialProvider = ShareTextImageAndUlrWithSpacificApp(img: UIImage(), url: URL(string: "http://www.google.com")! , title: String())
        let activityViewController = UIActivityViewController(activityItems: [socialProvider], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func actionShareVideo(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareVideoVC") as? ShareVideoVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func SchoolPost(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolPostVC") as? SchoolPostVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func SchoolPolls(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolPollsVC") as? SchoolPollsVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func MyMessages(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyMessagesVC") as? MyMessagesVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func MyEvents(_ button:UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as? EventsVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }

}

class ShareTextImageAndUlrWithSpacificApp: NSObject, UIActivityItemSource {
    var img: UIImage?
    var url: URL?
    var title : String?

    convenience init(img: UIImage, url: URL,title:String) {
        self.init()
        self.img = img
        self.url = url
        self.title = title
    }

    // This will be called BEFORE showing the user the apps to share (first step)
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return img!
    }

    // This will be called AFTER the user has selected an app to share (second step)
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        var objectsToShare = String()
        
        let linkText = "https://apps.apple.com/us/app/my-school-kinect/id1537795272"
        
        
        objectsToShare = "Let's bring our school together. Download My School Kinect.\n\(linkText)"
        
        return objectsToShare
        
        
    }
}
