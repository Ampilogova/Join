//
//  ChannelModel.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/27/20.
//

import Foundation
import SwiftyJSON
import Firebase

public struct ChannelModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension ChannelModel: JSONParsable {
    
    static func from(_ json: JSON) -> ChannelModel? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return ChannelModel(identifier: json["identifier"].stringValue,
                            name: json["name"].stringValue,
                            lastMessage: json["lastMessage"].stringValue,
                            lastActivity: dateFormatter.date(from: json["lastActivity"].stringValue))
    }
    
    static func from(_ dict: [String: Any], id: String) -> ChannelModel? {
        let name = dict["name"] as? String ?? ""
        let lastMessage = dict["lastMessage"] as? String ?? ""
        let timestamp = dict["lastActivity"] as? Timestamp
        
        return ChannelModel(identifier: id,
                            name: name,
                            lastMessage: lastMessage,
                            lastActivity: timestamp?.dateValue())
    }
}
