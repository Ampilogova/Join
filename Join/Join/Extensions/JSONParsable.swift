//
//  JSONParsable.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/27/20.
//

import Foundation
import SwiftyJSON

protocol JSONParsable {
    
    // Crete self from json
    static func from(_ json: JSON) -> Self?
    
    // Crete self from json and Id
    static func from(_ json: JSON, id: String) -> Self?
}

extension JSONParsable {
    
    static func from(_ json: JSON) -> Self? {
        return nil
    }
    
    static func from(_ json: JSON, id: String) -> Self? {
        return from(json)
    }
}

