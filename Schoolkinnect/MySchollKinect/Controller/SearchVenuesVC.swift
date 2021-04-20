//
//  SearchVenuesVC.swift
//  TradeSMart
//
//  Created by Shreyansh on 29/04/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SearchVenueDelegate: class {
    
    func selectedVenue(obj:[String:String]?)
}

class SearchVenuesVC: BaseVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSearchResult: UITableView!
    
    fileprivate var arrVenues = [JSON]()
    
    var delegate : SearchVenueDelegate?
    
    let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    let keyFourSquareClientID = "Y3SCHEJJB1GPBX3PAZ5EBJYNIQ4TQMADFYOU3LNGW4Q43S3N"
    let keyFourSquareClientSecret = "25ORNIMG1ZGUPMO2CBUAHXWCYYGBRC0G025EI3A01CZBDXUB"
    let KeyVFourSquareKey = "20190425"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
}

//MARK:- Custom methods
extension SearchVenuesVC {
    
    func setUpUI(){
        self.tblSearchResult.tableFooterView = UIView()
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
    }
    
    func setUpData() {
        
    }
    
    func searchFourSquareVenue(searchKeyword:String) {
        
        self.showSpinner(onView: self.view)
        
        let strLatLng = "\(APP_DELEGATE.latitute),\(APP_DELEGATE.longtitute)"
        
        self.callFourSquareVenueAPI(endpoint: "https://api.foursquare.com/v2/venues/search?client_id=Y3SCHEJJB1GPBX3PAZ5EBJYNIQ4TQMADFYOU3LNGW4Q43S3N&client_secret=25ORNIMG1ZGUPMO2CBUAHXWCYYGBRC0G025EI3A01CZBDXUB&v=20190425&limit=20&ll=37.4220019%2C-122.0839998&radius=10000&intent=browse&query=gala", success: { (Response) in
            Print(object: Response)
        }) { (failure) in
            Print(object: failure)
        }
        
//
    }
    
    func callFourSquareVenueAPI(endpoint : String,method: HTTPMethod = .get, success: @escaping (JSON) -> Void, failure: @escaping (String) -> Void) {
        
        guard let url = URL(string: endpoint.replacingOccurrences(of: " ", with: "%20")) else {
            failure("Something went wrong")
            return
        }
        print("New URL -------------\(url)")
        
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 80000
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) in
            
            
            if let value = responseObject.value {
                
                print("\n\n\n\n=======================================================")
                print("JSON RESPONSE:\n",JSON(value))
                print("=======================================================")
                
                let json = value
                  success(JSON(json))
            } else {
                
                print("\n\n\n\n=======================================================")
                //                        print("parameters:\n",parameters)
                print("=======================================================")
                
                failure("JSON Response serialization failed...!   Error: \(String(describing: responseObject.error))")
            }
        }
    }
    
}

//MARK:- UISearchbar delegate
extension SearchVenuesVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.selectedVenue(obj: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if let keyWord = searchBar.text?.trim(), keyWord.count > 0 {
            self.searchFourSquareVenue(searchKeyword: keyWord)
        }else {
            if self.arrVenues.count > 0 {
                self.arrVenues.removeAll()
            }
            self.tblSearchResult.reloadData()
        }
    }
}

//MARK:- UITableView Delegate & Datasource
extension SearchVenuesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrVenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCellIdentifier", for: indexPath) as! SearchCell
        
        let objDict = self.arrVenues[indexPath.row].dictionaryValue
        cell.lblTitle.text = objDict["name"]?.stringValue ?? ""
        cell.lblDetail.text = objDict["location"]?.dictionaryValue["address"]?.stringValue ?? ""//objDict["location"]?.dictionaryValue["formattedAddress"]?.stringValue ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objDict = self.arrVenues[indexPath.row].dictionaryValue
        
        var dictData = ["address":objDict["location"]?.dictionaryValue["address"]?.stringValue ?? ""]
        dictData["lat"] = objDict["location"]?.dictionaryValue["lat"]?.stringValue ?? ""
        dictData["lng"] = objDict["location"]?.dictionaryValue["lng"]?.stringValue ?? ""
        
        self.delegate?.selectedVenue(obj: dictData)
    }
}


class SearchCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
