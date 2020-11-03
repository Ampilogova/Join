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
        dateLabel.text = currentTime(date: model.created)
        
        self.backgroundColor = .clear
    }
}
extension OutgoingMessageCell {
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
