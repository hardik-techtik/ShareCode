//
//  addSchool.swift
//  MySchollKinect
//
//  Created by Admin on 14/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct School: Codable {
    let firstname, lastname, schoolMascot, email: String?
    let phone, theNameOfYourSchool, city, state: String?
    let zipCode, address: String?
    let userID: Int?
    let updatedAt, createdAt: String?
    let id: Int?
    

    enum CodingKeys: String, CodingKey {
        case firstname, lastname
        case schoolMascot = "school_mascot"
        case email, phone
        case theNameOfYourSchool = "the_name_of_your_school"
        case city, state
        case zipCode = "zip_code"
        case address
        case userID = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        
    }
}
