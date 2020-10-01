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
    
    private func currentTime(date: Date) -> String {
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
    
    func configure(with model: ConversationModel) {
        nameLabel.text = model.name
        hasUnreadMessages = model.hasUnreadMessages
        avatarView.configure(model.name)
        date = model.date
        isOnline = model.isOnline
        if isOnline == true {
            backgroundColor = .lightYellow
        } else if hasUnreadMessages == true {
            messageLabel.text = model.message
            messageLabel.font = .boldSystemFont(ofSize: 16)
        } else if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 15)
        } else {
            messageLabel.text = model.message
            dateLabel.text = currentTime(date: model.date)
        }
        dateLabel.text = currentTime(date: model.date)
    }
}

// MARK: - ConfigurableView
protocol ConfigurationView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
