//
//  HelpCenterVC.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import ExpandableCell

class HelpCenterVC: BaseVC {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var BackView: UIView!
    var objArrHelpModel:[HelpNewModel] = []
    var objArrHelpModelMain:[HelpNewModel] = []
    var isContactClick = false
    @IBOutlet weak var viewToolsMenu: UIView!
    @IBOutlet weak var btnSidemenu: SidemenuButton!
    
    
    @IBOutlet weak var txtsearchField: RDSearchTextField!
    
    var selectedIndex : Int = -1
    
    var arrCell:[ExpandableCell2]!
    
    var isFromBlock = Bool()
    
    //@IBOutlet weak var footerContactViewHeight: NSLayoutConstraint!
//     @IBOutlet weak var objTableViewHeight: NSLayoutConstraint!
//    var parentCells: [[String]] = [
//        [ExpandableCell2.ID,
//         ExpandableCell2.ID,
//         ExpandableCell2.ID,
//        ]
//    ]

    var cell: UITableViewCell {
        return tblView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.estimatedRowHeight = 55
        //tblView.register(UINib(nibName: "HelpCenterFooterCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "HelpCenterFooterCell")
        //self.tblView.dataSource = self
        txtsearchField.delegate = self
        
        //self.tblView.expandableDelegate = self
        //self.tblView.animation = .automatic
        
//        tblView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: NormalCell.ID)
//        tblView.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
//        tblView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
//        tblView.register(UINib(nibName: "ExpandableSelectableCell", bundle: nil), forCellReuseIdentifier: ExpandableSelectableCell2.ID)
//        tblView.register(UINib(nibName: "InitiallyExpandedExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableInitiallyExpanded.ID)
        
        
        self.tblView.setEmptyMessage1111("No question found")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        BackView.AddDefaultShadow()
        self.showSpinner(onView: self.view)
        GetHelpList()
        
        if isFromBlock == true {
            self.viewToolsMenu.isHidden = true
            self.btnSidemenu.isHidden = true
        }else{
            self.viewToolsMenu.isHidden = false
            self.btnSidemenu.isHidden = false
        }
        
    }
    
    @objc func actionHedaer(btnHeader:UIButton) {
        print("-- -header tag -- \(btnHeader.tag)")
        self.selectedIndex = btnHeader.tag
        self.tblView.reloadData()
    }
    
    func GetHelpList() {
        let serviceManager = ServiceManager<events>.init()
        
        let headers: HTTPHeaders =  ["Accept":"application/json"]
        AF.request("\(serviceManager.Url + serviceManager.ClientVersion)faqs", method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.removeSpinner()
            }
            switch response.result {
            case .success(_):
                guard let json = response.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.error {
                        print("Error: \(error)")
                    }
                    return
                }
                 guard let message = json["message"] as? [[String: Any]] else {
                    print("Could not get todo title from JSON")
                    return
                }
                self.objArrHelpModel = message.map({ (oneDict) -> HelpNewModel in
                    return HelpNewModel(json: oneDict)
                })
                self.objArrHelpModelMain = self.objArrHelpModel
                
                if self.objArrHelpModel.count == 0 {
                    self.tblView.setEmptyMessage1111("No question found")
                } else {
                    self.tblView.setEmptyMessage1111("")
                }
                
                self.tblView.reloadData()
                
                //self.setupCell()
//                self.objTableViewHeight.constant = self.objArrHelpModelMain.count *
                print("---------")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    /*func setupCell(){

        DispatchQueue.main.async {
            var i = 0
            for item in self.objArrHelpModel {
                let cell2 = UINib(nibName: "ExpandedCell", bundle: nil)
                self.tblView.register(cell2, forCellReuseIdentifier: "ExpandedCell\(i)")
                
                let cell = UINib(nibName: "ExpandableCell", bundle: nil)
                self.tblView.register(cell, forCellReuseIdentifier: "ExpandableCell\(i)")
                i+=1
            }

            self.tblView.reloadData()
             self.tblView.reloadData()
        }

    }*/
    
    /*@IBAction func buttonContactAction(_ sender: UIButton) {
//        var isContactClick = false
        if isContactClick == true {
            footerContactViewHeight.constant = 250
            isContactClick = false
        } else {
            footerContactViewHeight.constant = 82
            isContactClick = true
        }
    }*/
    
    @objc func actionContactUs(btnContact:UIButton) {
        self.selectedIndex = btnContact.tag
        self.tblView.reloadData()
    }
    
    @available(iOS 13.0, *)
    func validateContactForm(uName:String?,email:String?,query:String?) {
        guard let name = uName else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter name",onVc:self)
            return
        }
        
        guard let email = email else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter email address",onVc:self)
            return
        }
        
        guard let q = query?.trim() else {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter question",onVc:self)
            return
        }
        
        if q == "" {
            RDalertcontoller().presentAlertWithMessage(Message:"Please enter question",onVc:self)
            return
        }
        
        let serviceManager = ServiceManager<ResponseModelSuccess>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "contact-us"
        serviceManager.Parameters = ["name":name,"email":email,"question":q]
        
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let response = Response as? ResponseModelSuccess
            
            self.selectedIndex = -1
            self.tblView.reloadData()
            
            DispatchQueue.main.async {
                guard let thankYouVC : ContactUsThankYouVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsThankYouVc") as? ContactUsThankYouVc else { return }
                self.navigationController?.pushViewController(thankYouVC, animated: true)
            }
            
            //RDalertcontoller().presentAlertWithMessage(Message:response?.errorMsg ?? "",onVc:self)
            
            
            
            
        }
        
    }
}

extension HelpCenterVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.objArrHelpModel.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCellIdentifier") as? ContactUsCell
            cell?.txtEmail.text = User.shared.email
            
            if isFromBlock == true {
                cell?.txtName.placeholder = "Your Name"
            }
            else{
                cell?.txtName.text = (User.shared.firstName ?? "") + " " + (User.shared.lastName ?? "")
            }
            
            cell?.contactUsCompletion = { (username, useremail, userquery) in
                if #available(iOS 13.0, *) {
                    self.validateContactForm(uName: username, email: useremail, query: userquery)
                } 
            }
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCenterCell") as? HelpCenterCell
            cell?.lblQuestion.text = self.objArrHelpModel[indexPath.section].answer
            return cell ?? UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objArrHelpModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selectedIndex {
            return UITableView.automaticDimension
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.objArrHelpModel.count {
            let vw : vwContactUs = Bundle.main.loadNibNamed("vwContactUs", owner: self, options: nil)?.first as! vwContactUs
            vw.btnContactUs.tag = section
            vw.btnContactUs.addTarget(self, action: #selector(self.actionContactUs(btnContact:)), for: UIControl.Event.touchUpInside)
            return vw
        }else {
            let vw : HelpCenterHeaderVw = Bundle.main.loadNibNamed("HelpCenterHeader", owner: self, options: nil)?.first as! HelpCenterHeaderVw
            if section == selectedIndex {
                vw.imgDropDown.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }else {
                vw.imgDropDown.transform = CGAffineTransform(rotationAngle: 0)
            }
            vw.lblQuestion.text = self.objArrHelpModel[section].question
            vw.btnHeader.tag = section
            vw.btnHeader.addTarget(self, action: #selector(self.actionHedaer(btnHeader:)), for: UIControl.Event.touchUpInside)
            return vw
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.objArrHelpModel.count {
            return 80
        }else {
            return 60
        }
        
    }
}

/*extension HelpCenterVC:UITableViewDelegate,UITableViewDataSource/*,ExpandableDelegate*/ {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let vw : HelpCenterHeaderVw = UINib(nibName: "HelpCenterHeaderVw.xib", bundle: nil).fi as! HelpCenterHeaderVw
        let vw : HelpCenterHeaderVw = Bundle.main.loadNibNamed("HelpCenterHeaderVw", owner: self, options: nil)?.first as! HelpCenterHeaderVw
        return vw
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objArrHelpModel.count + 1
    }
    
    
    
    
    /*func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell1 = tblView.dequeueReusableCell(withIdentifier: "ExpandedCell\(indexPath.section)") as! ExpandedCell
        cell1.titleLabel.text = self.objArrHelpModel[indexPath.section].answer
        return [cell1]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        //return self.objArrHelpModel.count == 0 ? 0 : self.objArrHelpModel.count
        return self.objArrHelpModel.count + 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        //        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.titleLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String? {
        return "Section:\(section)"
    }
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: "ExpandableCell\(indexPath.section)")  else { return UITableViewCell() }
        (cell as! ExpandableCell2).titleLable.text = self.objArrHelpModel[indexPath.section].question
        (cell as! ExpandableCell2).rightMargin = 50
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc(expandableTableView:didCloseRowAt:) func expandableTableView(_ expandableTableView: UITableView, didCloseRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //        let cell = expandableTableView.cellForRow(at: indexPath)
        //        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //        cell?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]?{
        return [UITableView.automaticDimension]
    }*/
//    func expandableTableView(_ expandableTableView: ExpandableTableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: "HelpCenterFooterCell") as! HelpCenterFooterCell
//        //        headerView.labelTitle.text = "Sometimes you just need some answers! we've listed below popular questions we've found people have been asking when booking a xxx (master category) task."
//        //        headerView.labelTitle.numberOfLines = 0
//        //        headerView.labelTitle.lineBreakMode = .byWordWrapping
//        //        headerView.objBtnContact.tag = indexPath.row
//                headerView.ContactButtonClickClosure = { (name: Bool, intIndex: Int) in
//                    self.isContactClick = name
//                    self.tblView.reloadData()
//                }
//                return headerView
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//         if self.isContactClick == true {
//                   return 250
//               } else {
//                   return 80
//               }
//    }
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objArrHelpModel.count == 0 ? 0 : self.objArrHelpModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCenterCell") as? HelpCenterCell
        cell?.lblQuestion.text = self.objArrHelpModel[indexPath.row].question
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }*/
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HelpCenterFooterCell") as! HelpCenterFooterCell
////        headerView.labelTitle.text = "Sometimes you just need some answers! we've listed below popular questions we've found people have been asking when booking a xxx (master category) task."
////        headerView.labelTitle.numberOfLines = 0
////        headerView.labelTitle.lineBreakMode = .byWordWrapping
////        headerView.objBtnContact.tag = indexPath.row
//        headerView.ContactButtonClickClosure = { (name: Bool, intIndex: Int) in
//            self.isContactClick = name
//            self.tblView.reloadData()
//        }
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if self.isContactClick == true {
//            return 250
//        } else {
//            return 80
//        }
////        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 50.0
//    }
}
*/
extension HelpCenterVC: UITextFieldDelegate,RDSearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        objArrHelpModel.removeAll()
        if (textField.text?.count ?? 0) > 0 {
            self.objArrHelpModel = self.objArrHelpModelMain.filter({ value -> Bool in
                guard let text =  textField.text else { return false}
                print(value)
                return (value.question.lowercased().contains(text.lowercased()) || value.answer.lowercased().contains(text.lowercased()))
            })
        } else {
            self.objArrHelpModel = self.objArrHelpModelMain
        }

        print("-----\(self.objArrHelpModel)")
        if self.objArrHelpModel.count == 0 {
            self.tblView.setEmptyMessage1111("No question found")
        } else {
            self.tblView.setEmptyMessage1111("")
        }
        self.tblView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
