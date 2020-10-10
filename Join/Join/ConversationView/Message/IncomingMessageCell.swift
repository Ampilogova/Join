//
//  IncomingMessageCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class IncomingMessageCell: UITableViewCell, ConfigurationView {
    
    @IBOutlet var incomingMessageLabel: UILabel!
    let themeService = ThemeService()
    
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        incomingMessageLabel.text = model.text
        incomingMessageLabel.layer.cornerRadius = 6
        incomingMessageLabel.layer.masksToBounds = true
        incomingMessageLabel.backgroundColor = themeService.currentTheme().incoming
        self.backgroundColor = .clear
    }
}
