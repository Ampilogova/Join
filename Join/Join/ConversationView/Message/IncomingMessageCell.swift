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
        dateLabel.text = currentTime(date: model.created)
        self.backgroundColor = .clear
    }
}
extension IncomingMessageCell {
    func currentTime(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.string(from: date)
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            dateFormatter.dateFormat = "dd-MMM"
            dateFormatter.string(from: date)
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
    }
}
