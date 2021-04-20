//
//  MyContactsVC.swift
//  MySchollKinect
//
//  Created by Admin on 01/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class MyContactsVC: BaseVC {
    
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var tblView: reloadTable!
    @IBOutlet weak var txtsearchField: RDSearchTextField!
    var contacts:[ContactNewModel] = []
    var contactsMain:[ContactNewModel] = []
    var Filteredcontacts:[Contacts] = []
    var contactDictionary = [String: [String]]()
    var contactSectionTitles = [String]()
    var contactDictionaryMain = [String: [String]]()
    var contactSectionTitlesMain = [String]()
    var isSearching = false
    
    let Indexes = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let blankIndexes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.sectionIndexColor = UIColor.init(hexFromString: "666666")
        self.tblView.RefresgDelegete = self
//        txtsearchField.delegate = self
        
        txtsearchField.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMycontacts()
//        BackView.AddDefaultShadow()
    }
    
    @IBAction func openMemeberSearch(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MemberSearchVC") as? MemberSearchVC
            else {return}
        self.navigationController?.show(vc, sender: nil)
    }
    
    
    
}

extension MyContactsVC:refreshProtocol
{
    func didRefresh(tableView: UITableView) {
        self.getMycontacts()
    }
    
    func deleteConfirmation(section:Int,item:Int) {
        self.showAlert(msg: "Are you sure you want to delete contact?", okBtnTitle: "Yes", cancelBtnTitle: "No", okBtnCompletion: {
            print("-----Section \(section) ----- item ---- \(item)")
            let id = self.contactsMain[item].id ?? 0
            self.DeleteContact(ID: "\(id)")
            
        }) {
            
        }
    }
    
}



extension MyContactsVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactSectionTitles.count
    }
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return contactSectionTitles[section]
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
        
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 5, width: 
            tableView.bounds.size.width, height: 30))
        headerLabel.font = UIFont(name: "Verdana", size: 15)
        headerLabel.textColor = UIColor.black
        headerLabel.text = contactSectionTitles[section]
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let carKey = contactSectionTitles[section]
        if let carValues = contactDictionary[carKey] {
            return carValues.count
        }
//        return self.contacts.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            self.deleteConfirmation(section: indexPath.section, item: indexPath.row)
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let Contact = self.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSearchCell") as? MemberSearchCell
        
        cell?.selectionStyle = .none
        
        cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.height ?? 0.0)/2
        cell?.imgProfile.layer.masksToBounds = true
      
        let carKey = contactSectionTitles[indexPath.section]
        if let carValues = contactDictionary[carKey] {
            cell?.lblName.text = carValues[indexPath.row].components(separatedBy: "--+--").first ?? ""//Contact.name
            
            cell?.imgProfile.sd_setImage(with: URL.init(string: carValues[indexPath.row].components(separatedBy: "++----++").last ?? ""), placeholderImage: UIImage.placeholder, options: SDWebImageOptions.continueInBackground)
            
        }else {
            return cell ?? UITableViewCell()
        }
        
        return cell ?? UITableViewCell()
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
               let carKey = contactSectionTitles[indexPath.section]
        if let carValues = contactDictionary[carKey] {
            let ID = carValues[indexPath.row].components(separatedBy: "--+--").last?.components(separatedBy: "++----++").first ?? ""
            vc.postID = Int(ID) ?? 0
            self.navigationController?.show(vc, sender: nil)
        }else{
            RDalertcontoller().presentAlertWithMessage(Message:"User not found",onVc:self)
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if contactsMain.count > 0 {
            return self.Indexes//self.contactSectionTitles
        } else {
            return self.blankIndexes
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension MyContactsVC: UITextFieldDelegate,RDSearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.contacts.removeAll()
        if textField.text!.count == 0 {
            self.contacts = self.contactsMain
//            self.contactDictionary = self.contactDictionaryMain
        } else {
            self.contacts = self.contactsMain.filter { (contact) -> Bool in
                return (contact.name).localizedCaseInsensitiveContains(textField.text ?? "")
            }
//             self.contactDictionary = self.contactDictionaryMain.filter { (contact) -> Bool in
//                return (contact.key).localizedCaseInsensitiveContains(textField.text ?? "")
//             }
        }
        self.contactDictionaryMain.removeAll()
        self.contactDictionary.removeAll()
        self.contactSectionTitles.removeAll()
        self.contactSectionTitlesMain.removeAll()
        
        for car in self.contacts {
            print(car.name)
            let str = car.name.uppercased()
            if str == "" || str == " " || str == "  " || str == "   " {
                print(str)
            } else {
                let carKey = String(str.prefix(1))
                if var carValues = self.contactDictionary[carKey] {
                    carValues.append(car.name + "--+--\(car.toUserID)" + "++----++\(car.userMember.first?.profilePic ?? "")")
                    self.contactDictionary[carKey] = carValues
                } else {
                    self.contactDictionary[carKey] = [car.name + "--+--\(car.toUserID)" + "++----++\(car.userMember.first?.profilePic ?? "")"]
                }
            }
        }
        self.contactDictionaryMain = self.contactDictionary

        self.contactSectionTitles = [String](self.contactDictionary.keys)
        self.contactSectionTitles = self.contactSectionTitles.sorted(by: { $0 < $1 })

        self.contactSectionTitlesMain  = [String](self.contactDictionary.keys)
        self.contactSectionTitlesMain = self.contactSectionTitles.sorted(by: { $0 < $1 })
    
        if self.contactsMain.count == 0 {
            self.tblView.setEmptyMessage1111("No contacts found")
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
//MARK:- services
extension MyContactsVC {
    
//    func callAPItoDeleteContact(conacts:[String],index:Int) {
//
//        let name = conacts[index].components(separatedBy: "--+--").first ?? ""//Contact.name
//
//        let ID = conacts[index].components(separatedBy: "--+--").last?.components(separatedBy: "++----++").first ?? ""
//
//        print("name is ---- \(name) ------- id is ------ \(ID)")
//
//        /*let serviceManager = ServiceManager<ResponseModelSuccess>.init()
//         serviceManager.ShowLoader = true
//         serviceManager.ServiceName = "contact-member/\(ID)"
//
//         serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
//         let response = Response as? ResponseModelDic<ResponseModelSuccess>
//         print(response)
//         //self.navigationController?.popViewController(animated: true)
//         }*/
//
//
//        let serviceManager = ServiceManager<events>.init()
//
//        let token = UserDefaults.standard.object(forKey: "logintoken")  as? String
//        let authToken = (token == nil || token == "") ? "" : token ?? ""
//
//        AF.request("\(serviceManager.Url)\(serviceManager.ClientVersion)contact-member/\(ID)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(authToken)"]).responseJSON { (responseObject) in
//
//            if let value = responseObject.value {
//
//
//                print(responseObject)
//            } else {
//
//                print("\n\n\n\n=======================================================")
//                //                        print("parameters:\n",parameters)
//                print("=======================================================")
//
//                RDalertcontoller().presentAlertWithMessage(Message:"Something went wrong.",onVc:self)
//
//                //failure("JSON Response serialization failed...!   Error: \(String(describing: responseObject.error))")
//            }
//        }
//
//    }
    
    func getMycontacts() {
        
        //self.showSpinner(onView: self.view)
        //self.tblView.setEmptyMessage1111("Please wait")
        let serviceManager = ServiceManager<Contacts>.init()
        serviceManager.ServiceName = "contact-member/\(User.shared.id ?? 0)"
        
        let token = UserDefaults.standard.object(forKey: "logintoken")  as? String
        print("Authorization token-----\(token ?? "")")
        let authToken = (token == nil || token == "") ? ""   : token ?? ""
        let headers: HTTPHeaders =  ["Authorization":"Bearer \(authToken)","Accept":"application/json"]
        print("contact API name ---------\(serviceManager.Url + serviceManager.ClientVersion)contact-member/\(User.shared.id ?? 0)")
        AF.request("\(serviceManager.Url + serviceManager.ClientVersion)contact-member/\(User.shared.id ?? 0)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                
                self.tblView.refreshControl?.endRefreshing()
            }
            switch response.result {
            case .success(_):
                self.tblView.setEmptyMessage1111("")
                //self.removeSpinner()
                guard let json = response.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.error {
                        print("Error: \(error)")
                        
                    }
                    return
                }
                
                 guard let message = json["data"] as? [[String: Any]] else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                if self.contacts.count > 0 {
                    self.contacts.removeAll()
                }
                
                if self.contactsMain.count > 0 {
                    self.contactsMain.removeAll()
                }
                
                if self.contactDictionary.count >  0 {
                    self.contactDictionary.removeAll()
                }
                
                if self.contactDictionaryMain.count >  0{
                    self.contactDictionaryMain.removeAll()
                }
                
                self.contacts = message.map({ (oneDict) -> ContactNewModel in
                    return ContactNewModel(json: oneDict)
                })
                
                self.contactsMain = self.contacts
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                               self.removeSpinner()
                           }
                           for car in self.contactsMain {

                            print(car.name)
                            let str = car.name.uppercased()
                               if str == "" || str == " " || str == "  " || str == "   " {
                                print(str)
                               } else {
                                let carKey = String(str.prefix(1))
                                   if var carValues = self.contactDictionary[carKey] {
                                        carValues.append(car.name + "--+--\(car.toUserID)" + "++----++\(car.userMember.first?.profilePic ?? "")")
                                       self.contactDictionary[carKey] = carValues
                                   } else {
                                        self.contactDictionary[carKey] = [car.name + "--+--\(car.toUserID)" + "++----++\(car.userMember.first?.profilePic ?? "")"]
                                   }
                               }
                           }
                           self.contactDictionaryMain = self.contactDictionary
                           
                           self.contactSectionTitles = [String](self.contactDictionary.keys)
                           self.contactSectionTitles = self.contactSectionTitles.sorted(by: { $0 < $1 })
                   
                           self.contactSectionTitlesMain  = [String](self.contactDictionary.keys)
                           self.contactSectionTitlesMain = self.contactSectionTitles.sorted(by: { $0 < $1 })
                           
                           
                if self.contactsMain.count == 0 {
                    self.tblView.setEmptyMessage1111("No contacts found")
                } else {
                    self.tblView.setEmptyMessage1111("")
                }
                self.tblView.reloadData()
                 
                print("---------")
            case let .failure(error):
                print(error)
                self.removeSpinner()
                self.tblView.setEmptyMessage1111("")
            }
        }
    }
    
    
    func DeleteContact(ID:String)
    {
        let servicemanager = ServiceManager<UserContact>.init()
        servicemanager.ServiceName = "contact-member/\(ID)"
        servicemanager.MakeServiceCall(httpMethod: .delete) { (response) in
            self.didRefresh(tableView: self.tblView)
            //RDalertcontoller().presentAlertWithMessage(Message:(response as? ResponseModelDic<UserContact>)?.errorMsg ?? "" , onVc: self)
        }
    }
    
}
