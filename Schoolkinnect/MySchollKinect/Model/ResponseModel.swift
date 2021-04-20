//
//  ResponseModel.swift
//  CityGuideApp
//
//  Created by mac on 26/09/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


enum AnyTypeError:Error {
    case valueNotFound
}

enum AnyType:Codable
{
    
    case string(String)
//    case int(Int)
//    case double(Double)
    
    var value:Any
    {
        return self
    }
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self)
        {
            self = .string(string)
            return
        }
//
//        if let int = try? decoder.singleValueContainer().decode(Int.self)
//        {
//            self = .int(int)
//            return
//        }
//
//        if let double = try? decoder.singleValueContainer().decode(Double.self)
//        {
//            self = .double(double)
//            return
//        }
        throw AnyTypeError.valueNotFound
    }
    
    
    func encode(to encoder: Encoder) throws {
        
    }
}


protocol GenericResponse:Codable {
    var statusCode: Int? {get}
    var errorMsg: String? {get}
}

struct ResponseModel<T:Codable>:Codable,GenericResponse
{
    let statusCode: Int?
    let errorMsg: String?
    let Data: [T]?
    let token: String?
    
    enum CodingKeys:String,CodingKey {
        
        case statusCode = "status_code"
        case errorMsg = "message"
        case Data = "data"
        case token
    }
}

struct ResponseModelDic<T:Codable>:Codable,GenericResponse
{
    
    let statusCode: Int?
    let errorMsg: String?
    let Data: T?
    let token:String?
    
    enum CodingKeys:String,CodingKey {
        
        case statusCode = "status_code"
        case errorMsg = "message"
        case Data = "data"
        case token
        
    }
}

struct ResponseModelSuccess:Codable,GenericResponse
{
    let statusCode: Int?
    let errorMsg: String?
    let Data: String?
    
    enum CodingKeys:String,CodingKey {
        case statusCode = "status_code"
        case errorMsg = "message"
        case Data = "data"
    }
}

struct ResponseModelSuccessStatus:Codable
{
    var statusCode: String?
    let errorMsg: String?
    let Data: String?
    
    enum CodingKeys:String,CodingKey {
        case statusCode = "status_code"
        case errorMsg = "message"
        case Data = "data"
    }
}
