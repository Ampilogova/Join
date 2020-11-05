//
//  ConversationsListViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import UIKit
import Firebase
import SwiftyJSON

class ConversationsListViewController: UIViewController, UITableViewDelegate {
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var chats = [ChannelModel]()

    let themeService = ThemeService()
    var chatTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        createNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToUpdates()
    }
    
    private func createNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Channels"
        let settingsButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(presentSettingsButton))
        settingsButtonItem.tintColor = .gray
        self.navigationItem.leftBarButtonItem  = settingsButtonItem
        
        let profileButtonItem = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(presentProfileButton))
        let createChatButtonItem = UIBarButtonItem(image: UIImage(named: "addChat"), style: .plain, target: self, action: #selector(createChatButton))
        profileButtonItem.tintColor = .gray
        createChatButtonItem.tintColor = .gray
        self.navigationItem.rightBarButtonItems = [profileButtonItem, createChatButtonItem]
    }
    
    private func createTable() {
        chatTableView = UITableView(frame: view.bounds, style: .plain)
        chatTableView.delegate = self
        chatTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(chatTableView)
        
        let nib = UINib(nibName: ChatCell.className, bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: ChatCell.className)
        chatTableView.dataSource = self
    }
    
    @objc func presentProfileButton() {
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    @objc func presentSettingsButton() {
        self.performSegue(withIdentifier: "settingSegue", sender: nil)
    }
    
    @objc func createChatButton() {
        showAlert()
    }
    
    func showAlert() {
        let showAlert = UIAlertController(title: "Создайте чат", message: nil, preferredStyle: .alert)
        showAlert.addTextField { (textField: UITextField!) in
            textField.placeholder = "Введите название чата"
        }
        let okAction = UIAlertAction(title: "ok", style: .default) { action in
            let text = showAlert.textFields?.first?.text ?? ""
            let identifier = UUID().uuidString
            //let identifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
            self.db.collection("channels").document().setData([
                "name": text,
                "identifier": identifier,
                "lastActivity": Timestamp(date: Date())
            ])
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        showAlert.addAction(okAction)
        showAlert.addAction(cancelAction)
        present(showAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingSegue" {
            let destinationVC = segue.destination as? ThemesViewController
            destinationVC?.selectedTheme = { [weak self] theme in
                self?.themeService.saveTheme(theme: theme)
                self?.chatTableView.reloadData()
            }
        }
    }
    
    private func subscribeToUpdates() {
        reference.order(by: "lastActivity", descending: true ).addSnapshotListener { (querySnapshot, error) in
            self.chats = querySnapshot?.documents.compactMap({
                                                                ChannelModel.from($0.data(), id: $0.documentID) }) ?? []
            self.chatTableView.reloadData()
            StorageManager.shareInstance.saveContext()
        }
    }
}


// MARK: - Table view data source

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.className, for: indexPath) as? ChatCell else {
            preconditionFailure("ChatCell can't to dequeued")
        }
        let model = chats[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ConversationViewController()
        viewController.name = chats[indexPath.row].name
        viewController.channel = chats[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        
        db.collection("channels").document(chats[indexPath.row].identifier).collection("messages")
            .getDocuments { (querySnapshot, error) in

        }
    }
}


