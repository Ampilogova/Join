//
//  OutgoingMessageCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class OutgoingMessageCell: UITableViewCell, ConfigurationView {
    
    typealias ConfigurationModel = MessageModel
    
    @IBOutlet var outgoingMessageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    let themeService = ThemeService()
    
    func configure(with model: MessageModel) {
        outgoingMessageLabel.text = model.content
        outgoingMessageLabel.layer.cornerRadius = 6
        outgoingMessageLabel.layer.masksToBounds = true
        outgoingMessageLabel.backgroundColor = themeService.currentTheme().outgoing
        dateLabel.text = model.created?.formatedTime()
        
        self.backgroundColor = .clear
    }
}

