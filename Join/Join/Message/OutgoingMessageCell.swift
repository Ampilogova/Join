//
//  OutgoingMessageCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class OutgoingMessageCell: UITableViewCell, ConfigurationView {

    typealias ConfigurationModel = MessageCellModel
    
    @IBOutlet var outgoingMessageLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        outgoingMessageLabel.text = model.text
        outgoingMessageLabel.backgroundColor = .customGreen
        outgoingMessageLabel.layer.cornerRadius = 6
        outgoingMessageLabel.layer.masksToBounds = true

    }
    
}
