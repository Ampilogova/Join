//
//  ChatCell.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import UIKit

class ChatCell: UITableViewCell, ConfigurationView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var avatarContainerView: UIView!
    
    let themeService = ThemeService()
    let avatarView = AvatarView.fromNib()
    var isOnline: Bool?
    var hasUnreadMessages: Bool?
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarContainerView.makeRounded()
        avatarContainerView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor),
            avatarView.topAnchor.constraint(equalTo: avatarContainerView.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor)
        ])
        avatarView.avatarLabel.font = .systemFont(ofSize: 15)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.font = nil
        backgroundColor = nil
    }
    
    private func currentTime(date: Date?) -> String {
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
    
    func setupCurrentTheme() {
        backgroundColor = themeService.currentTheme().backgroundColor
        nameLabel.textColor = themeService.currentTheme().textColor
        messageLabel.textColor = themeService.currentTheme().textColor
        dateLabel.textColor = themeService.currentTheme().textColor
    }
    
    func configure(with model: Channel) {
        nameLabel.text = model.name
        avatarView.configure(model.name ?? "")
        date = model.lastActivity
        if hasUnreadMessages == true {
            messageLabel.text = model.lastMessage
            messageLabel.font = .boldSystemFont(ofSize: 17)
        } else if model.lastMessage?.isEmpty == false {
            messageLabel.text = model.lastMessage
            dateLabel.text = currentTime(date: model.lastActivity)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 15)
        }
        dateLabel.text = currentTime(date: model.lastActivity)
        setupCurrentTheme()
    }
}

