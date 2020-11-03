//
//  ConversationViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    var name: String?
    var channel: ChannelModel?
    var chatTableView = UITableView()
    let textField = UITextField()
    let themeService = ThemeService()
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var messages = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        createTable()
        setupTextField()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToUpdates()
    }
    
    private func createTable() {
        chatTableView = UITableView(frame: view.bounds, style: .grouped)
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
    
    func setupTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
        textField.backgroundColor = .red
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let id = channel?.identifier ?? ""
        reference.document(id).collection("messages").document().setData([
            "content": textField.text ?? "",
            "created": Timestamp(date: Date()),
            "senderId": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "senderName": "Tatiana"
        ])
        
        return true
    }
    
    private func createNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = name
    }
    
    private func subscribeToUpdates() {
        guard let id = channel?.identifier, !id.isEmpty else {
            return
        }
        reference.document(id).collection("messages").order(by: "created").addSnapshotListener { (querySnapshot, error) in
            self.messages = querySnapshot?.documents.compactMap({ MessageModel.from($0.data()) }) ?? []
            self.chatTableView.reloadData()
        }
    }
}

// MARK: - Table view data source
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].senderId == UIDevice.current.identifierForVendor?.uuidString {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingMessageCell.className, for: indexPath) as? OutgoingMessageCell else { preconditionFailure("OutgoingMessageCell can't to dequeued") }
            let model = messages[indexPath.row]
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingMessageCell.className, for: indexPath) as? IncomingMessageCell else { preconditionFailure("IncomingMessageCell can't to dequeued") }
            let model = messages[indexPath.row]
            cell.configure(with: model)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
