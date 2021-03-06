//
//  MessageCellModel.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import Foundation

struct MessageCellModel {
    let text: String
    let type: TypeDirection
    
    enum TypeDirection {
        case incoming
        case outgoing
    }
}
