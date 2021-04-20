//
//  EventsVC.swift
//  MySchollKinect
//
//  Created by Admin on 28/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
//import Lightbox
import AVKit

class EventsVC: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var tblView: reloadTable!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var AddEventsVC: UIButton!
    @IBOutlet weak var txtSearchEvents: RDSearchTextField!
    @IBOutlet weak var lbllEvetTitle: UILabel!
    var events:[events] = []
    var eventsMain:[events] = []
    var issearching = false
    var fromvc = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.RefresgDelegete = self
        self.AddEventsVC.addTarget(self, action: #selector(AddEvents(_:)), for: .touchUpInside)

        txtSearchEvents.setLeftPaddingPoints(10)
        txtSearchEvents.delegate = self
        tblView.tableFooterView = UIView()
        self.tblView.setEmptyMessage1111("No event found")
        txtSearchEvents.layer.cornerRadius = txtSearchEvents.bounds.height / 2
        
        self.txtSearchEvents.Delegate = self
        if fromvc
        {
            self.AddEventsVC.isHidden = true
            self.lbllEvetTitle.text = "My Events"
        }
        
        tblView.estimatedRowHeight = 450
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func AddEvents(_ button:UIButton) {
        guard let Vc = storyboard?.instantiateViewController(withIdentifier: "AddEventsVC") as? AddEventsVC else {return}
        self.navigationController?.show(Vc, sender:nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getEvents()
    }
    
}
extension EventsVC:refreshProtocol {
    func didRefresh(tableView: UITableView) {
        self.getEvents()
    }
}
extension EventsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell") as? EventsCell
        cell?.selectionStyle = .none
        
        cell?.vc = self
        cell?.cellIndex = indexPath.row
        
        var arrEventPhoto = [[String: Any]]()
        for photo in self.events[indexPath.row].userEventPhotos ?? [] {
            if let url = URL.init(string: photo.path ?? "") {
//                image.append(LightboxImage.init(imageURL: url))
                var dict = [String: Any]()
                dict["path"] = url
                dict["type"] = "image"
                arrEventPhoto.append(dict)
            }
        }
        for video in self.events[indexPath.row].userEventVideos ?? [] {
            if let url = URL.init(string: video.path ?? "") {
//                image.append(LightboxImage.init(imageURL: url))
                var dict = [String: Any]()
                dict["path"] = url
                dict["type"] = "video"
                arrEventPhoto.append(dict)
            }
        }
        
        cell?.updateArrayList(array: arrEventPhoto)
//        cell?.controller = LightboxController(images: image)
//        LightboxConfig.CloseButton.text = ""
//        if let controller = cell?.controller {
//            self.addChild(controller)
//            cell?.PostIMage.addSubview(controller.view)
//            controller.view.frame = cell?.PostIMage.bounds ?? CGRect.zero
//            controller.view.backgroundColor = UIColor.white
//            cell?.PostIMage.clipsToBounds = true
//            cell?.PostIMage.contentMode = .scaleAspectFill
//            cell?.controller?.didMove(toParent: self)
//        }
        
        cell?.objEventsCellDelegate = self
        cell?.lblName.text = self.events[indexPath.row].eventName
        
        /*let date = self.events[indexPath.row].eventTime ?? ""
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        let datedate = formatter.date(from: date)
        formatter.dateFormat = "dd MMM yyyy hh:mm a"
        let stingDate = formatter.string(from: datedate ?? Date())*/
        
        let strDate = Utility.shared.DateConvertToString(inputDateformate: "yyyy-MM-dd HH:mm:ss", outputDateformate: "dd MMM yyyy hh:mm a", strScheduleDate: self.events[indexPath.row].eventTime ?? "")
         cell?.lblDate.text = strDate
        
        cell?.horizontalView.collectionView.reloadData()
        
        /*if Int(self.events[indexPath.item].userID ?? "0") == User.shared.id {
            cell?.btnOptions.isHidden = false
        }else {
            cell?.btnOptions.isHidden = true
        }*/
        
        cell?.btnOptions.addTarget(self, action: #selector(options(_:)), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
    }   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailsVC") as? EventDetailsVC else {return}
        vc.Event = self.events[indexPath.row]
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func options(_ button:UIButton) {
        if (self.events[button.tag].userID ?? "") == "\((User.shared.id ?? 0))" {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                
                self.showAlert(msg: "Are you sure you want to delete this event?", okBtnTitle: "Yes", cancelBtnTitle: "No", okBtnCompletion: {
                    let Tag = button.tag
                    let id = self.events[Tag].id ?? 0
                    self.DeleteEvents(ID: id)
                }) {
                    print("No")
                }
            }
            
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEventVC") as? EditEventVC else { return }
                vc.EventToEdit = self.events[Tag]
                self.navigationController?.show(vc, sender: nil)
            }
            
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(UpdateAAction)
            Alert.addAction(DeleteAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        } else {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction.init(title: "Its inappropriate", style: .default) { (Action) in
            }
            let UpdateAAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                vc.ReportID = self.events[Tag].id ?? 0
                vc.For = "event"
                vc.userId = Int(self.events[Tag].userID!)!
                self.navigationController?.show(vc, sender: nil)
            }
            
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            //Alert.addAction(DeleteAction)
            Alert.addAction(UpdateAAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        }
    }
}
//MARK:- webServices
extension EventsVC {
    func getEvents() {
        let serviceManager = ServiceManager<events>.init()
        serviceManager.ShowLoader = true
        if fromvc
        {
            serviceManager.ServiceName = "user-event"
        }
        else
        {
            serviceManager.ServiceName = "event-all/\(User.shared.schoolID ?? 0)"
        }
        
        serviceManager.Parameters = ["search":self.txtSearchEvents.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let Posts = Response as? ResponseModel<events>
            self.events = Posts?.Data ?? []
            self.eventsMain = self.events
            self.tblView.refreshControl?.endRefreshing()
            if self.events.count == 0 {
                self.tblView.setEmptyMessage1111("No event found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            self.tblView.reloadData()
        }
    }
    func DeleteEvents(ID:Int) {
        let serviceManager = ServiceManager<events>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "event/\(ID)"
//        serviceManager.Parameters = ["search":self.txtSearchEvents.text ?? ""]
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            self.getEvents()
        }
    }
    @IBAction func buttonClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EventsVC:RDSearchTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count ?? 0) > 0 {
            
            self.events =  self.eventsMain.filter({ value -> Bool in
                guard let text =  textField.text else { return false}
                print(value)
                return  (value.eventLocation!.lowercased().contains(text.lowercased()) || value.eventName!.lowercased().contains(text.lowercased()) || value.latitude!.lowercased().contains(text.lowercased()) || value.longitude!.lowercased().contains(text.lowercased())) // According to title from JSON
                
            })
        } else {
            self.events = self.eventsMain
        }
//        self.arrProductModel = filterContentForSearchText(searchText: textField.text!)
        print("-----\(self.events)")
        if self.events.count == 0 {
            self.tblView.setEmptyMessage1111("No event found")
        } else {
            self.tblView.setEmptyMessage1111("")
        }
        self.tblView.reloadData()
    }
}
//extension EventsVC: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        txtSearchEvents.clearButtonMode = .always
////        txtSearchEvents.withImage(direction: .Right, image: UIImage() , colorSeparator: UIColor.clear, colorBorder: UIColor.clear)
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if (textField.text?.count ?? 0) > 0 {
//            //            for a
//            self.events = self.eventsMain.filter({ value -> Bool in
//                guard let text =  textField.text else { return false}
//                print(value)
//                return (value.eventLocation!.lowercased().contains(text.lowercased()) || value.eventName!.lowercased().contains(text.lowercased()) || value.latitude!.lowercased().contains(text.lowercased()) || value.longitude!.lowercased().contains(text.lowercased())) // According to title from JSON
//                
//            })
//        } else {
//            self.events = self.eventsMain
//        }
////        self.arrProductModel = filterContentForSearchText(searchText: textField.text!)
//        print("-----\(self.events)")
//        if self.events.count == 0 {
//            self.tblView.setEmptyMessage1111("No event found")
//        } else {
//            self.tblView.setEmptyMessage1111("")
//        }
//        self.tblView.reloadData()
//        txtSearchEvents.clearButtonMode = .never
////        txtSearchEvents.withImage(direction: .Right, image: #imageLiteral(resourceName: "Serch Blue") , colorSeparator: UIColor.clear, colorBorder: UIColor.clear)
//        
//    }
////    func filterContentForSearchText(searchText: String) -> [ProductModel]{
////        let arr = arrProductModelMain.filter { item in
////                    let arr = item.objProductModel.filter { item1 in
////                        return item1.productName.lowercased().contains(searchText.lowercased())
////                    }
////                    return true
////        //            return item.category_english.lowercased().contains(searchText.lowercased())
////                }
////        return arr
////    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        //        self.getEvents()
//        return true
//    }
//}
extension UITableView {

    func setEmptyMessage1111(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "SFProDisplay", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func setEmptyMsg(msg : String) {
        
        self.separatorStyle = .none
        self.reloadData()
        
        if self.numberOfRows(inSection: 0) == 0 {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = msg
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "SFProDisplay", size: 15)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel
            
        }else {
            self.backgroundView = nil
        }
        
    }
}
// MARK:  PostCellDelegate  
extension EventsVC: EventsCellDelegate {
    func displayVideoOptionInEventVC(urlOfVideo: URL) {
        let player = AVPlayer(url: urlOfVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func redirectToDetail(indx: Int) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetailsVC") as? EventDetailsVC else {return}
        vc.Event = self.events[indx]
        self.navigationController?.show(vc, sender: nil)
    }
}
