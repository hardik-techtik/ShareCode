//
//  HelpModel.swift
//  MySchollKinect
//
//  Created by Pritesh on 18/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct HelpModel: Codable {
    let statusCode: Int?
    let message: [message]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
    }
}

// MARK: - Message
struct message: Codable {
    let id: Int?
    let question, answer, status, createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, question, answer, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
