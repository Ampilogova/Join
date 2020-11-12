//
//  ConversationsListViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import UIKit
import Firebase
import CoreData
import SwiftyJSON

class ConversationsListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    var chats = [ChannelModel]()
    var fetchedResultController: NSFetchedResultsController<Channel>?
    
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
        loadSavedData()
        setupCurrentTheme()
    }
    
    func loadSavedData() {
        if fetchedResultController == nil {
            let request = NSFetchRequest<Channel>(entityName: "Channel")
            let sort = NSSortDescriptor(key: "lastActivity", ascending: false)
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
    func setupCurrentTheme() {
        navigationController?.navigationBar.backgroundColor = themeService.currentTheme().backgroundColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeService.currentTheme().textColor]
        
    }
    
    private func subscribeToUpdates() {
        reference.order(by: "lastActivity", descending: true ).addSnapshotListener { (querySnapshot, error) in
            self.chats = querySnapshot?.documents.compactMap({
                                                                ChannelModel.from($0.data(), id: $0.documentID) }) ?? []
            self.chatTableView.reloadData()
            StorageManager.shareInstance.deleteChannels()
            for chat in self.chats {
                let channel = Channel(context: StorageManager.shareInstance.context)
                channel.identifier = chat.identifier
                channel.lastMessage = chat.lastMessage
                channel.name = chat.name
                channel.lastActivity = chat.lastActivity
            }
            StorageManager.shareInstance.saveContext()
        }
    }
    
    private func deleteData(identifier: String) {
        reference.document(identifier).delete() { (err) in
            if err != nil {
                print("error")
            } else {
                print("deleted")
            }
        }
    }
}


// MARK: - Table view data source

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultController?.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.className, for: indexPath) as? ChatCell else {
            preconditionFailure("ChatCell can't to dequeued")
        }
        let channel = fetchedResultController?.object(at: indexPath)
        cell.configure(with: channel ?? Channel())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ConversationViewController()
        viewController.name = fetchedResultController?.object(at: indexPath).name
        viewController.channel = fetchedResultController?.object(at: indexPath)
        viewController.id = fetchedResultController?.object(at: indexPath).identifier ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultController?.object(at: indexPath)
            StorageManager.shareInstance.context.delete(channel ?? Channel())
            deleteData(identifier: fetchedResultController?.object(at: indexPath).identifier ?? "")
            StorageManager.shareInstance.saveContext()
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.reloadData()
    }
}


