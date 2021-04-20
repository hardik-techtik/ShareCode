//
//  ScoketRTC.swift
//  MiracleMind
//
//  Created by Tarak Parikh on 26/11/19.
//  Copyright © 2019 Techtic Solutions. All rights reserved.
//

import Foundation
import SocketIO

struct JoinRoom : SocketData {
    let userId : String
    func socketRepresentation() -> SocketData {
        return ["room":"room_\(userId)"]
    }
}
class SocketHelper : NSObject{
    static let shared = SocketHelper()
     var buttonClickClosureInGlobal: ((Int) -> ())?
    
    //live url http://www.myschoolkinect.com:4200/
    // dev url
    static let liveUlrSocket = "http://www.myschoolkinect.com:4300/"
    static let devUrl = "http://45.79.111.106:4200/"
    let manager = SocketManager(socketURL: URL(string: liveUlrSocket)!, config: [.log(false), .compress])
    //let manager = SocketManager(socketURL: URL(string: devUrl)!, config: [.log(false), .compress])
    var socket:SocketIOClient!
    func connect() {
        socket = manager.defaultSocket
        self.listenEvent()
        socket.connect()
    }
    
    func disconnect()
    {
        socket.disconnect()
    }
    
    func Login(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.emit("login", User.shared.id ?? 0)
    }
    
    
    func joinRoom(sender_id:String,receiver_id:String) {
        guard socket.status == .connected else {
            print("Not connected")
            return
        }
        let joinRoom = JoinRoom(userId: sender_id)
        socket.emit("login", joinRoom) {
            print("connected to room \(sender_id) to \(receiver_id)")
        }
    }
    
    func getAllMessages(sender_id:Int,receiver_id:Int,completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
//        let send = sender_id.data(using: .utf8, allowLossyConversion: false)!
//        let rec = receiver_id.data(using: .utf8, allowLossyConversion: false)!
        print("-------sender id -------messages-------\(sender_id)")
        print("-------receiver_id ----messages-------\(receiver_id)")
        socket.emitWithAck("messages",sender_id,receiver_id).timingOut(after: 5.0) { (arrAck) in
            
              print("arrAck\(arrAck)")
            if (arrAck[0] as AnyObject).isKind(of: NSString.self) {
                completionHandler(NSMutableDictionary())
                return
            }else {
                let array:NSArray = arrAck[0] as! NSArray
                if(array.count == 0){
                    let messageDictionary = NSMutableDictionary()
                     messageDictionary.setValue(-1, forKey:"id")
                     completionHandler(messageDictionary)
                    return
                }
                for each in array {
                    let messageDictionary = NSMutableDictionary()
                    let aDictMessage = (each as! NSDictionary)
                    messageDictionary.setValue(aDictMessage.value(forKey:"id"), forKey:"id")
                    //                messageDictionary.setValue(aDictMessage.value(forKey:"body"), forKey:"body")
                    let str = ((aDictMessage.value(forKey:"body") as? String) == nil) ? "" : (aDictMessage.value(forKey:"body") as! String).decodeUrl()
                    messageDictionary.setValue(str, forKey:"body")
//                    let messageDelieverd = ((aDictMessage.value(forKey:"delivered_at") as? String) == nil) ? "" : (aDictMessage.value(forKey:"delivered_at") as! String)
                    messageDictionary.setValue(aDictMessage.value(forKey:"media_path"), forKey:"media_path")
                    messageDictionary.setValue(aDictMessage.value(forKey:"contact_id"), forKey:"contact_id")
                    messageDictionary.setValue(aDictMessage.value(forKey:"user_id"), forKey:"user_id")
                    messageDictionary.setValue(aDictMessage.value(forKey:"created_at"), forKey:"created_at")
                    messageDictionary.setValue(aDictMessage.value(forKey:"read_at"), forKey:"read_at")
                    completionHandler(messageDictionary)
                }
            }
        }
    }
    func sendMessage(sender_id:Int,receiver_id:Int,strMessage: String,completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
       let obj = Messagedata.init(senderID: sender_id, RecieverID: receiver_id, message: strMessage)
        debugPrint(obj.message,obj.senderID,obj.RecieverID)
        socket.emitWithAck("message", obj).timingOut(after: 2.0) { (res) in
            completionHandler(res)
        }
    }
    func getConversation(sender_id:Int, completionHandler: @escaping (_ messageInfo: NSDictionary?) -> Void) {
        self.socket.emitWithAck("conversation_users", with: [sender_id]).timingOut(after: 2.0) { (dict) in
            print("get_message-----dict---\(dict)")
            if (dict[0] as AnyObject).isKind(of: NSString.self) {
                completionHandler(NSMutableDictionary())
                return
            }else {
                let array:NSArray = dict[0] as! NSArray
                if array.count > 0 {
                    for each in array {
                        let messageDictionary = NSMutableDictionary()
                        let aDictMessage = (each as! NSDictionary)
                        messageDictionary.setValue(aDictMessage.value(forKey:"id"), forKey:"id")
                        
                        messageDictionary.setValue(aDictMessage.value(forKey:"created_at"), forKey:"created_at")
                        messageDictionary.setValue(aDictMessage.value(forKey:"date_of_birth"), forKey:"date_of_birth")
                        messageDictionary.setValue(aDictMessage.value(forKey:"email"), forKey:"email")
                        messageDictionary.setValue(aDictMessage.value(forKey:"age"), forKey:"age")
                        messageDictionary.setValue(aDictMessage.value(forKey:"apple_id"), forKey:"apple_id")
                        messageDictionary.setValue((aDictMessage.value(forKey:"first_name") as! String), forKey:"first_name")
                        messageDictionary.setValue(aDictMessage.value(forKey:"gender"), forKey:"gender")
                        messageDictionary.setValue(aDictMessage.value(forKey:"last_name"), forKey:"last_name")
                        messageDictionary.setValue(aDictMessage.value(forKey:"latitude"), forKey:"latitude")
                        messageDictionary.setValue(aDictMessage.value(forKey:"longitude"), forKey:"longitude")
                        messageDictionary.setValue(aDictMessage.value(forKey:"profile_pic"), forKey:"profile_pic")
                        
                        messageDictionary.setValue(aDictMessage.value(forKey:"school_classigication"), forKey:"school_classigication")
                        messageDictionary.setValue(aDictMessage.value(forKey:"school_major"), forKey:"school_major")
                        messageDictionary.setValue(aDictMessage.value(forKey:"school_minor"), forKey:"school_minor")
                        messageDictionary.setValue(aDictMessage.value(forKey:"school_university"), forKey:"school_university")
                        
                        messageDictionary.setValue(aDictMessage.value(forKey:"unread_count"), forKey:"unread_count")
                        messageDictionary.setValue(aDictMessage.value(forKey:"status"), forKey:"status")
                        messageDictionary.setValue(aDictMessage.value(forKey:"last_message"), forKey:"last_message")
                        
                        completionHandler(messageDictionary)
                    }
                }else {
                    completionHandler(nil)
                }
                
                
            }
        }
    }
    func DeletePerticularMessage(sender_id:Int,receiver_id:Int,message_id: Int,completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        socket.emitWithAck("delete_message", DeleteMessagedata.init(senderID: sender_id, RecieverID: receiver_id, MessageID: message_id)).timingOut(after: 2.0) { (res) in
            print("get_message-----res---\(res)")
            self.socket.emitWithAck("message_deleted", with: [sender_id,receiver_id]).timingOut(after: 2.0) { (dict) in
                print("message_deleted-----dict---\(dict)")
            }
            completionHandler(res)
        }
    }
    // delete conversation
    func deleteConversationOrClearChat(deleted_by:Int,deleted_to:[Int],completionHandler: @escaping (_ messageInfo: String) -> Void) {
        socket.emit("delete_conversation", DeleteUserConversationdata.init(deleted_by: deleted_by, deleted_to: deleted_to)) {
        //socket.emitWithAck("delete_conversation", DeleteUserConversationdata.init(deleted_by: deleted_by, deleted_to: deleted_to)) .timingOut(after: 2.0) { (res) in
            print("delete Message : ")
            completionHandler("messageInfo")
        }
    }
    //Unread count from all message
    func UnreadFromAllMessage(from_user_id:Int, completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
    
            print(AllUnreadMessageData.init(sender_id: from_user_id))
        socket.emitWithAck("request_unread_count", AllUnreadMessageData.init(sender_id: from_user_id)) .timingOut(after: 2.0) { (res) in
            print("request_unread_count :-- \(res)")
//            self.socket.on("get_unread_count") { (data, ack) in
//                print("request_unread_count 2....:-- ")
//                let messageDictionary = NSMutableDictionary()
//                let aDictMessage = data[0] as! NSDictionary
//                messageDictionary.setValue(aDictMessage.value(forKey:"message_id"), forKey:"id")
//                completionHandler(messageDictionary)
//            }
            completionHandler(res)
        }
    }
    //block user
    func BlockUserAndChat(from_user_id:Int,to_user_id:[Int],completionHandler: @escaping (_ messageInfo: String) -> Void) {
        socket.emit("block_user", BlockUserData.init(from_user_id: from_user_id, to_user_id: to_user_id)) {
        //socket.emitWithAck("delete_conversation", DeleteUserConversationdata.init(deleted_by: deleted_by, deleted_to: deleted_to)) .timingOut(after: 2.0) { (res) in
            print("block user :-- ")
            completionHandler("BlockUserInfo")
        }
    }
    func SendMediaWithChat(sender_id:Int,receiver_id:Int, bufferData: Data,completionHandler: @escaping (_ messageInfo: String) -> Void) {
        print("send Media :-- ")
        socket.emit("send_media", SendMediaWithSocketData.init(sender_id: sender_id, receiver_id: receiver_id, mediaIsSelect: true, bufferData: bufferData)) {
            completionHandler("image upload successfully")
        }
    }
    func UserTyping(sender_id:Int,receiver_id:Int, typingStatus:Bool,completionHandler: @escaping (_ messageInfo: String) -> Void) {
        socket.emit("typing", UserTypingData.init(sender_id: sender_id, receiver_id: receiver_id, typingStatus: typingStatus)) {
            print("user typing:-- ")
            completionHandler("typing")
        }
    }
    func receiveTypingEvent(completionHandler: @escaping (_ messageInfo: String) -> Void) {
        socket.on("typing") {data,ack in
            print("receive typing : -------\(data)----ack-----\(ack)")
            completionHandler("typing")
        }
    }
    func listenEvent() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected from listen event")
            let joinRoom = JoinRoom(userId: "\(User.shared.id ?? 0)")
            self.UnreadFromAllMessage(from_user_id: User.shared.id ?? 0) { (data) in
                print("data request_unread_count :-- ",data.first!)
                let arr = data.first as? [[String: Any]]
                let dict = arr?.first?["unread_count"] as? Int
                print("data request_unread_count :-- \(dict ?? 0)")
                if self.buttonClickClosureInGlobal != nil {
                    self.buttonClickClosureInGlobal!(dict ?? 0)
                }
            }
            self.socket.emit("login", User.shared.id ?? 0) {
                print("connected to room ",joinRoom)
            }
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected from listen event")
        }
        socket.on("join") { (dataArray, socketAck) -> Void in
            print(dataArray,socketAck)
        }
        socket.on("messages") { (dataArray, socketAck) -> Void in
            print(dataArray,socketAck)
        }
        socket.on("request_unread_count") { (dataArray, socketAck) -> Void in
            print("request_unread_count ----", dataArray,socketAck)
        }
    }
    
    func sendMessage(message:[String:Any]) {
        socket.emit("message",message) {
            print("Sent Message : ",message)
        }
    }
   

    func onMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("get_message"){ (dataArray, socketAck) -> Void in
            let messageDictionary = NSMutableDictionary()
            let array = dataArray[0] as! NSArray
            let aDictMessage = (array[0] as! NSDictionary)
            messageDictionary.setValue(aDictMessage.value(forKey:"id"), forKey:"id")
            //            messageDictionary.setValue(aDictMessage.value(forKey:"body"), forKey:"body")
            messageDictionary.setValue((aDictMessage.value(forKey:"body") as? String ?? "").decodeUrl(), forKey:"body")
            messageDictionary.setValue(aDictMessage.value(forKey:"contact_id"), forKey:"contact_id")
            messageDictionary.setValue(aDictMessage.value(forKey:"user_id"), forKey:"user_id")
            messageDictionary.setValue(aDictMessage.value(forKey:"created_at"), forKey:"created_at")
            messageDictionary.setValue(aDictMessage.value(forKey:"read_at"), forKey:"read_at")
           // self.sendDelivery(sender_id:String(messageDictionary.value(forKey:"contact_id") as! Int), receiver_id: String(messageDictionary.value(forKey:"user_id") as! Int), message_id:String( messageDictionary.value(forKey:"id") as! Int))
            completionHandler(messageDictionary)
        }
    }
    func onMessageDeliverd(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("message_delivered"){ (dataArray, socketAck) -> Void in
            let messageDictionary = NSMutableDictionary()
            let aDictMessage = dataArray[0] as! NSDictionary
            messageDictionary.setValue(aDictMessage.value(forKey:"message_id"), forKey:"id")
            messageDictionary.setValue(aDictMessage.value(forKey:"receiver_id"), forKey:"contact_id")
            messageDictionary.setValue(aDictMessage.value(forKey:"sender_id"), forKey:"user_id")
            completionHandler(messageDictionary)
        }
    }
   
    
    func onMessageReaded(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("message_read"){ (dataArray, socketAck) -> Void in
            let messageDictionary = NSMutableDictionary()
            let aDictMessage = dataArray[0] as! NSDictionary
            //            messageDictionary.setValue(String(decoding: aDictMessage.value(forKey:"message_id") as! Data, as: UTF8.self), forKey:"id")
            messageDictionary.setValue(aDictMessage.value(forKey:"receiver_id"), forKey:"contact_id")
            messageDictionary.setValue(aDictMessage.value(forKey:"sender_id"), forKey:"user_id")
            completionHandler(messageDictionary)
        }
    }
    
    func DeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("delete_message"){ (dataArray, socketAck) -> Void in
            let messageDictionary = NSMutableDictionary()
            let aDictMessage = dataArray[0] as! NSDictionary
            //            messageDictionary.setValue(String(decoding: aDictMessage.value(forKey:"message_id") as! Data, as: UTF8.self), forKey:"id")
            messageDictionary.setValue(aDictMessage.value(forKey:"receiver_id"), forKey:"contact_id")
            messageDictionary.setValue(aDictMessage.value(forKey:"sender_id"), forKey:"user_id")
            completionHandler(messageDictionary)
        }
        
    }
    
    func sendDelivery(sender_id:Int,receiver_id:Int,message_id:Int) {
        //        let rec = sender_id.data(using: .utf8, allowLossyConversion: false)!
        //        let send = receiver_id.data(using: .utf8, allowLossyConversion: false)!
        //        let msg = message_id.data(using: .utf8, allowLossyConversion: false)!
//        let dictData = NSDictionary(dictionary: ["sender_id":sender_id,"receiver_id":receiver_id,"message_id":message_id])
//        let arrData:NSArray = NSArray(array: [dictData])
        socket.emitWithAck("mark_messages_delivered",receiver_id,sender_id,message_id).timingOut(after: 5.0) { (arrAck) in
            print("Message Sent From: sendDelivery-----",receiver_id )
            print("Message Delivered To:  sendDelivery-----", sender_id)
            print("Message :",message_id)
        }
    }
    
    func sendReadAll(sender_id:Int,receiver_id:Int) {
        //        let send = sender_id.data(using: .utf8, allowLossyConversion: false)!
        //        let rec = receiver_id.data(using: .utf8, allowLossyConversion: false)!
//        let dictData = NSDictionary(dictionary: ["sender_id":sender_id,"receiver_id":receiver_id])
//        let arrData = NSArray(array: [dictData])
        socket.emitWithAck("mark_messages_read",sender_id,receiver_id).timingOut(after: 5.0) { (arrAck) in
            print("Message Sent From: sendReadAll----",sender_id )
            print("Message Read by: sendReadAll----",receiver_id )
        }
    }
}

struct ReadDictArray  : SocketData  {
    let sender_id : String
    let receiver_id:String
    
    func socketRepresentation() -> SocketData {
        let dict = ["sender_id":sender_id,"receiver_id":receiver_id]
        //        let arr = [dict]
        let dictData = NSDictionary(dictionary: ["sender_id":sender_id,"receiver_id":receiver_id])
        let arrData = NSArray(array: [dictData])
        return arrData
    }
}
struct DeliveryDictArray : SocketData  {
    let sender_id : String
    let receiver_id:String
    let message_id:String
    func socketRepresentation() -> SocketData {
        let dict = ["sender_id":sender_id,"receiver_id":receiver_id,"message_id":message_id]
        //        let arr = [dict]
        let dictData = NSDictionary(dictionary: ["sender_id":sender_id,"receiver_id":receiver_id,"message_id":message_id])
        let arrData = NSArray(array: [dictData])
        return arrData
    }
}
