//
//  Uplods.swift
//  MySchollKinect
//
//  Created by Admin on 13/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

struct uploads: Codable {
    
    let uploadImagePath: String?
    let userID: Int?
    let updatedAt, createdAt: String?
    let id: Int?
    let image: Data?

    enum CodingKeys: String, CodingKey {
        case uploadImagePath = "path"
        case userID = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case image
    }
}


