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
    
    let themeService = ThemeService()
    
    typealias ConfigurationModel = MessageModel
    
    func configure(with model: MessageModel) {
        incomingMessageLabel.text = model.content
        incomingMessageLabel.layer.cornerRadius = 6
        incomingMessageLabel.layer.masksToBounds = true
        incomingMessageLabel.backgroundColor = themeService.currentTheme().incoming
        dateLabel.text = model.created?.formatedTime()
        self.backgroundColor = .clear
    }
}
