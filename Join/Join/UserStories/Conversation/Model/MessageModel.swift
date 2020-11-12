//
//  MessageModel.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/27/20.
//

import Foundation
import SwiftyJSON
import Firebase

struct MessageModel {
    let content: String
    let created: Date?
    let senderId: String
    let senderName: String
}

extension MessageModel: JSONParsable {
    
    static func from(_ json: JSON) -> MessageModel? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return MessageModel(content: json["content"].stringValue,
                            created: dateFormatter.date(from: json["lastActivity"].stringValue),
                            senderId: json["senderId"].stringValue,
                            senderName: json["senderName"].stringValue)
    }
    
    static func from(_ dict: [String: Any]) -> MessageModel? {
        let content = dict["content"] as? String ?? ""
        let timestamp = dict["created"] as? Timestamp
        let senderId = dict["senderId"] as? String ?? ""
        let senderName = dict["senderName"] as? String ?? ""
        
        return MessageModel(content: content,
                            created: timestamp?.dateValue(),
                            senderId: senderId,
                            senderName: senderName)
    }
}
