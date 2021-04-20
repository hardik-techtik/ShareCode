//
//  Profile.swift
//  MySchollKinect
//
//  Created by Admin on 15/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct UserProfile: Codable {
    
    let id: Int?
    let firstName: String?
    let lastName, dateOfBirth, gender, relationshipStatus: String?
    let schoolMajor, schoolMinor, latitude, fourDigitPin: String?
    let longitude, expectedGradutionDate, schoolClassigication: String?
    let useFourDigitPin:Int?
    let interest, aboutYourself, profilePic, schoolUniversity: String?
    let email: String?
    let emailVerifiedAt, age, deviceType, status: String?
    let appleID: String?
    let name: String?
    let schoolpostCount, schooleventCount,school_poll_count: Int?
    var photos: [uploads]?
    let user_contact : [UserContact]?
    let is_active : Int?
    
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
        case interest = "interest"
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
        case is_active
        case schoolpostCount = "schoolpost_count"
        case schooleventCount = "schoolevent_count"
        case photos
        case user_contact = "user_contact"
        case school_poll_count = "school_poll_count"
    }
}


//
//  Profile.swift
//  MySchollKinect
//
//  Created by Admin on 15/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct UpdateUserProfile: Codable {
    let id: Int?
    let firstName: String?
    let lastName, dateOfBirth, gender, relationshipStatus: String?
    let schoolMajor, schoolMinor, latitude, fourDigitPin: String?
    let longitude, expectedGradutionDate, schoolClassigication: String?
    let useFourDigitPin:Int?
    let interest, aboutYourself, profilePic, schoolUniversity: String?
    let email: String?
    let emailVerifiedAt , deviceType, status: String?
    let appleID: String?
    let name: String?
    let schoolpostCount,age, schooleventCount: Int?
    var photos: [uploads]?

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
        case interest = "interest"
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
        case photos
    }
}
