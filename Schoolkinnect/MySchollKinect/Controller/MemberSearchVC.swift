//
//  MemberSearchVC.swift
//  MySchollKinect
//
//  Created by Admin on 31/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class MemberSearchVC: BaseVC {

    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var tblView: reloadTable!
    var contacts:[Member] = []
    var contactsMain:[Member] = []
    var Filteredcontacts:[Member] = []
    var contactDictionary = [String: [String]]()
    var contactSectionTitles = [String]()
    var contactDictionaryMain = [String: [String]]()
    var contactSectionTitlesMain = [String]()
    var isSearching = false
    @IBOutlet weak var btnphoneBook: UIButton!
    
    @IBOutlet weak var txtSearch: RDSearchTextField!
    
    let Indexes = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let blankIndexes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.RefresgDelegete = self
        self.tblView.sectionIndexColor = UIColor.init(hexFromString: "666666")
        
        self.txtSearch.delegate = self
        
        self.btnphoneBook.addTarget(self, action: #selector(OpenPhoneBook(_:)), for: .touchUpInside)
        
        getMycontacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        BackView.AddDefaultShadow()
    }
    
    @objc func OpenPhoneBook(_ button:UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as? MyContactsVC else { return }
        self.navigationController?.show(vc, sender: nil)
    }
    
    
    @IBAction func openMyContacts(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as? MyContactsVC else {
            return
        }
    }
}


extension MemberSearchVC: refreshProtocol {
    func didRefresh(tableView: UITableView) {
        
        self.getMycontacts()
    }
}

extension MemberSearchVC: RDSearchTextFieldDelegate,UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.contacts.removeAll()
        if textField.text!.count == 0 {
            self.contacts = self.contactsMain
//            self.contactDictionary = self.contactDictionaryMain
        } else {
            self.contacts = self.contactsMain.filter { (contact) -> Bool in
                return (contact.name)!.localizedCaseInsensitiveContains(textField.text ?? "")
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

            print(car.name!)
            let str = car.name?.uppercased()
            if str == "" || str == " " || str == "  " || str == "   " {
                print(str!)
            } else {
                let carKey = String(str!.prefix(1))
                if var carValues = self.contactDictionary[carKey] {
                    //carValues.append(car.name!)
                    carValues.append(car.name! + "--+--\(car.id ?? 0)" + "++----++\(car.profilePic ?? "")")

                    self.contactDictionary[carKey] = carValues
                } else {
                    self.contactDictionary[carKey] = [car.name! + "--+--\(car.id ?? 0)" + "++----++\(car.profilePic ?? "")"]
                }
            }
        }
        self.contactDictionaryMain = self.contactDictionary

        self.contactSectionTitles = [String](self.contactDictionary.keys)
        self.contactSectionTitles = self.contactSectionTitles.sorted(by: { $0 < $1 })

        self.contactSectionTitlesMain  = [String](self.contactDictionary.keys)
        self.contactSectionTitlesMain = self.contactSectionTitles.sorted(by: { $0 < $1 })
        
        self.tblView.reloadData()
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.contacts.removeAll()
        if textField.text!.count == 0 {
            self.contacts = self.contactsMain
//            self.contactDictionary = self.contactDictionaryMain
        } else {
            self.contacts = self.contactsMain.filter { (contact) -> Bool in
                return (contact.name)!.localizedCaseInsensitiveContains(textField.text ?? "")
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

            print(car.name!)
            let str = car.name?.uppercased()
            if str == "" || str == " " || str == "  " || str == "   " {
                print(str!)
            } else {
                let carKey = String(str!.prefix(1))
                if var carValues = self.contactDictionary[carKey] {
                    carValues.append(car.name!)

                    self.contactDictionary[carKey] = carValues
                } else {
                    self.contactDictionary[carKey] = [car.name!]
                }
            }
        }
        self.contactDictionaryMain = self.contactDictionary

        self.contactSectionTitles = [String](self.contactDictionary.keys)
        self.contactSectionTitles = self.contactSectionTitles.sorted(by: { $0 < $1 })

        self.contactSectionTitlesMain  = [String](self.contactDictionary.keys)
        self.contactSectionTitlesMain = self.contactSectionTitles.sorted(by: { $0 < $1 })
        
        self.tblView.reloadData()
    }
//    func filterContentForSearchText(searchText: String) -> [ProductModel]{
//        let arr = arrProductModelMain.filter { item in
//                    let arr = item.objProductModel.filter { item1 in
//                        return item1.productName.lowercased().contains(searchText.lowercased())
//                    }
//                    return true
//        //            return item.category_english.lowercased().contains(searchText.lowercased())
//                }
//        return arr
//    }
    */
}
extension MemberSearchVC:UITableViewDelegate,UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let Contact = self.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSearchCell") as? MemberSearchCell
        
        cell?.selectionStyle = .none
        
        cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.height ?? 0.0)/2
        cell?.imgProfile.layer.masksToBounds = true
//
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
//        return self.Indexes//self.contactSectionTitles
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
extension MemberSearchVC {
    func getMycontacts() {
        let serviceManager = ServiceManager<Member>.init()
        serviceManager.ServiceName = "member"
        serviceManager.ShowLoader = true
        
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let contatcts = Response as? ResponseModel<Member>
            self.contacts = contatcts?.Data ?? []
            self.contactsMain = self.contacts
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.removeSpinner()
                self.tblView.refreshControl?.endRefreshing()
            }
            
            if self.contactDictionary.count > 0 {
                self.contactDictionary.removeAll()
            }
            
            if self.contactDictionaryMain.count > 0 {
                self.contactDictionaryMain.removeAll()
            }
            
            for car in self.contacts {
                print(car.name!)
                let str = car.name?.uppercased()
                if str == "" || str == " " || str == "  " || str == "   " {
                    print(str!)
                } else {
                    let carKey = String(str!.prefix(1))
                    if var carValues = self.contactDictionary[carKey] {
                        carValues.append(car.name! + "--+--\(car.id ?? 0)" + "++----++\(car.profilePic ?? "")")
                        self.contactDictionary[carKey] = carValues
                    } else {
                        self.contactDictionary[carKey] = [car.name! + "--+--\(car.id ?? 0)" + "++----++\(car.profilePic ?? "")"]
                    }
                }
            }
            
            
            
            self.contactDictionaryMain = self.contactDictionary
            
            self.contactSectionTitles = [String](self.contactDictionary.keys)
            self.contactSectionTitles = self.contactSectionTitles.sorted(by: { $0 < $1 })
            
            self.contactSectionTitlesMain  = [String](self.contactDictionary.keys)
            self.contactSectionTitlesMain = self.contactSectionTitles.sorted(by: { $0 < $1 })
            
            if self.contactsMain.count == 0 {
                self.tblView.setEmptyMessage1111("No member found")
            } else {
                self.tblView.setEmptyMessage1111("")
            }
            self.tblView.reloadData()
        }
    }
}
