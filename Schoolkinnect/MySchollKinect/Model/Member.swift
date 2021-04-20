//
//  Contacts.swift
//  MySchollKinect
//
//  Created by Admin on 13/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Member: Codable {
    let id: Int?
    let firstName, lastName, dateOfBirth, gender: String?
    let relationshipStatus, schoolMajor, schoolMinor: String?
    let latitude, fourDigitPin: String?
    let useFourDigitPin: Int?
    let longitude: String?
    let expectedGradutionDate, schoolClassigication: String?
    let interest: String?
    let aboutYourself: String?
    let profilePic: String?
    let schoolUniversity: String?
    let email: String?
    let emailVerifiedAt: String?
    let age: String?
    let deviceType, status, appleID: String?
    let name: String?
    let schoolpostCount, schooleventCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case relationshipStatus = "relationship_status"
        case schoolMajor = "school_major"
        case schoolMinor = "school_minor"
        case latitude
        case fourDigitPin = "four_digit_pin"
        case useFourDigitPin = "use_four_digit_pin"
        case longitude
        case expectedGradutionDate = "expected_gradution_date"
        case schoolClassigication = "school_classigication"
        case interest
        case aboutYourself = "about_yourself"
        case profilePic = "profile_pic"
        case schoolUniversity = "school_university"
        case email
        case emailVerifiedAt = "email_verified_at"
        case age
        case deviceType = "device_type"
        case status
        case appleID = "apple_id"
        case name
        case schoolpostCount = "schoolpost_count"
        case schooleventCount = "schoolevent_count"
    }
}
