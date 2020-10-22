//
//  IncomingMessageCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class IncomingMessageCell: UITableViewCell, ConfigurationView {
    
    @IBOutlet var incomingMessageLabel: UILabel!
    
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        incomingMessageLabel.text = model.text
        incomingMessageLabel.backgroundColor = .customGray
        incomingMessageLabel.layer.cornerRadius = 6
        incomingMessageLabel.layer.masksToBounds = true
    }
}
