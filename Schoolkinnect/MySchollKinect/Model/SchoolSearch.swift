
//
//  SchoolSearch.swift
//  MySchollKinect
//
//  Created by Admin on 01/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct schools: Codable {
    let users: [Schools]?
    let nearbySchools: Int?

    enum CodingKeys: String, CodingKey {
        case users = "school"
        case nearbySchools = "nearby_schools"
    }
}

// MARK: - User
struct Schools: Codable {
    let id: Int?
    let firstname: String?
    let lastname, userID: String?
    let theNameOfYourSchool, schoolMascot, email, phone: String?
    let city, state, zipCode, country: String?
    let address, latitude, longitude, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname
        case userID = "user_id"
        case theNameOfYourSchool = "the_name_of_your_school"
        case schoolMascot = "school_mascot"
        case email, phone, city, state
        case zipCode = "zip_code"
        case country, address, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
