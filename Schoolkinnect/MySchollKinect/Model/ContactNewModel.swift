//
//  ContactNewModel.swift
//  MySchollKinect
//
//  Created by Pritesh on 29/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class ContactNewModel {

    var userMember:[ContactUserData] = []
    var id = Int()
    var toUserID = Int()
    var userID = Int()
    var name = ""
    var isFollow = 0
    var createdAt = ""
    var updatedAt = ""
    
    init() {}
    init(json : [String: Any]) {
        self.id = (json["id"] as? Int)!
        self.toUserID = (json["to_user_id"] as? Int)!
        self.userID = (json["user_id"] as? Int)!
        
        self.name = (json["name"] as? String)!
        self.isFollow = (json["is_follow"] as? Int)!
        self.createdAt = (json["created_at"] as? String)!
        self.updatedAt = (json["updated_at"] as? String)!
        
        let message = (json["user_member"] as? [[String: Any]])!
        
//        var arrPro = ContactUserData()
//        //            if dataOfJson != nil {
//        for each in message {
//            arrPro = ContactUserData(json: each)
//            self.userMember.append(arrPro)
//        }
        self.userMember = message.map({ (oneDict) -> ContactUserData in
            return ContactUserData(json: oneDict)
        })
    }
}
class ContactUserData {
    var id: Int = 0
    var firstName = ""
    var lastName = ""
    var dateOfBirth = ""
    var gender = ""
    
    var relationshipStatus = ""
    var schoolMajor = ""
    var schoolMinor: String = ""
    var profilePic: String = ""
    var email: String = ""

    var name: String = ""
    var  schoolID: Int = 0
    init() {}
    
    init(json : [String: Any]) {
        self.id = json["id"] as? Int ?? 0
        self.firstName = json["first_name"] as? String ?? ""
        self.lastName = json["last_name"] as? String ?? ""
        
        self.dateOfBirth = json["date_of_birth"] as? String ?? ""
        self.gender = json["gender"] as? String ?? ""
        self.relationshipStatus = json["relationship_status"] as? String ?? ""
        
        self.schoolMajor = json["school_major"] as? String ?? ""
        self.schoolMinor = json["school_minor"] as? String ?? ""
        self.profilePic = json["profile_pic"] as? String ?? ""
        
        self.email = json["email"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.schoolID = json["school_id"] as? Int ?? 0
    }
}
