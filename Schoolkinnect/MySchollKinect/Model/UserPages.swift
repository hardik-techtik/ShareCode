//
//  UserPages.swift
//  MySchollKinect
//
//  Created by Admin on 01/05/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct UserPages: Codable {
    let id: Int?
    let name, template, title, slug: String?
    let content: String?
    let extras: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, template, title, slug, content, extras
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
