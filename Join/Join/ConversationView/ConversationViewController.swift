//
//  ConversationViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate {
    
    var name: String?
    let themeService = ThemeService()
    
    var messages = [MessageCellModel(text: "Hi!", type: .incoming),
                    MessageCellModel(text: "Hello!", type: .outgoing),
                    MessageCellModel(text: "How are you?", type: .outgoing),
                    MessageCellModel(text: "I'm good! And you?", type: .incoming),
                    MessageCellModel(text: "Can I borrow a book please? will return after the weekend", type: .incoming),
                    MessageCellModel(text: "Sure", type: .outgoing),
                    MessageCellModel(text: "I can bring a book to the dining room at 2 PM", type: .outgoing),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        createTable()
    }
    
    private func createTable() {
        let chatTableView = UITableView(frame: view.bounds, style: .grouped)
        chatTableView.delegate = self
        chatTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(chatTableView)
        
        let nibIncomingMessage = UINib(nibName: IncomingMessageCell.className, bundle: nil)
        chatTableView.register(nibIncomingMessage, forCellReuseIdentifier: IncomingMessageCell.className)
        
        let nibOutgoingMessage = UINib(nibName: OutgoingMessageCell.className, bundle: nil)
        chatTableView.register(nibOutgoingMessage, forCellReuseIdentifier: OutgoingMessageCell.className)
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.backgroundColor = themeService.currentTheme().backgroundColor
    }
    
    private func createNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = name
    }
}

// MARK: - Table view data source
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].type == .incoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingMessageCell.className, for: indexPath) as? IncomingMessageCell else { preconditionFailure("IncomingMessageCell can't to dequeued") }
            let model = messages[indexPath.row]
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingMessageCell.className, for: indexPath) as? OutgoingMessageCell else { preconditionFailure("OutgoingMessageCell can't to dequeued") }
            let model = messages[indexPath.row]
            cell.configure(with: model)
            return cell
        }
    }
}
