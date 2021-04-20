//
//  searchSchoolvc.swift
//  MySchollKinect
//
//  Created by Admin on 01/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


protocol schoolDelegate:class {
    func didSelectSchool(school:Schools)
}

class searchSchoolvc: UITableViewController {
    
    enum fromVC {
        case serarch
        case SearchResults
    }
    
    weak var Delegate:schoolDelegate?

    var SelectdVC : fromVC = .serarch
    var School:[Schools] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return School.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "SearchCell")
        }
        cell?.textLabel?.text = self.School[indexPath.row].theNameOfYourSchool
        cell?.detailTextLabel?.text = self.School[indexPath.row].address
        return cell ?? UITableViewCell ()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.dismiss(animated: true, completion: nil)
        
        self.Delegate?.didSelectSchool(school: self.School[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}


