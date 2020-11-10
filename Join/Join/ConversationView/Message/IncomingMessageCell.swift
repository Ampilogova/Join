//
//  IncomingMessageCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class IncomingMessageCell: UITableViewCell, ConfigurationView {
    
    @IBOutlet var incomingMessageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    let themeService = ThemeService()
    
    typealias ConfigurationModel = Message
    
    func configure(with model: Message) {
        nameLabel.text = model.senderName
        incomingMessageLabel.text = model.content
        incomingMessageLabel.layer.cornerRadius = 6
        incomingMessageLabel.layer.masksToBounds = true
        incomingMessageLabel.backgroundColor = themeService.currentTheme().incoming
        dateLabel.text = model.created?.formatedTime()
        self.backgroundColor = .clear
    }
}
