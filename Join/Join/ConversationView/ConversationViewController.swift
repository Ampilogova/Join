//
//  ConversationViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var name: String?
    var channel: Channel?
    var chatTableView = UITableView()
    var textField = UITextField()
    let themeService = ThemeService()
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    var id = String()
    var messages = [MessageModel]()
    var fetchedResultController: NSFetchedResultsController<Message>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        createTable()
        setupTextField()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToUpdates()
        loadSavedData()
    }
    
    func loadSavedData() {
        if fetchedResultController == nil {
            let request = NSFetchRequest<Message>(entityName: "Message")
            let sort = NSSortDescriptor(key: "created", ascending: true)
            request.sortDescriptors = [sort]
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: StorageManager.shareInstance.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController?.delegate = self
        }
        do {
            try fetchedResultController?.performFetch()
            chatTableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            if self.messages.count > 0 {
                let index = IndexPath(row: self.messages.count - 1, section: 0)
                self.chatTableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createTable() {
        chatTableView = UITableView(frame: view.bounds, style: .grouped)
        chatTableView.delegate = self
        chatTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
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
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let id = self.id
        reference.document(id).collection("messages").document().setData([
            "content": textField.text ?? "",
            "created": Timestamp(date: Date()),
            "senderId": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "senderName": "Lala"
        ])
        textField.text = nil
        return true
    }
    
    private func createNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = name
    }
    
    private func subscribeToUpdates() {
        reference.document(self.id).collection("messages").order(by: "created").addSnapshotListener { (querySnapshot, error) in
            self.messages = querySnapshot?.documents.compactMap({ MessageModel.from($0.data()) }) ?? []
            self.chatTableView.reloadData()
            self.scrollToBottom()
            StorageManager.shareInstance.deleteMessages()
            for mes in self.messages {
                let message = Message(context: StorageManager.shareInstance.context)
                message.senderId = mes.senderId
                message.content = mes.content
                message.senderName = mes.senderName
                message.created = mes.created
            }
            StorageManager.shareInstance.saveContext()
        }
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        var moveUp = false
        
        let bottomOfTextView = textField.convert(textField.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfTextView > topOfKeyboard {
            moveUp = true
        }
        if(moveUp) {
            self.view.frame.origin.y = (0 - keyboardSize.height) + 25
        }
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}

// MARK: - Table view data source
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultController?.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fetchedResultController?.object(at: indexPath).senderId == UIDevice.current.identifierForVendor?.uuidString {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingMessageCell.className, for: indexPath) as? OutgoingMessageCell else { preconditionFailure("OutgoingMessageCell can't to dequeued") }
            let message = fetchedResultController?.object(at: indexPath)
            cell.configure(with: message ?? Message())
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingMessageCell.className, for: indexPath) as? IncomingMessageCell else { preconditionFailure("IncomingMessageCell can't to dequeued") }
            let message = fetchedResultController?.object(at: indexPath)
            cell.configure(with: message ?? Message())
            return cell
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
