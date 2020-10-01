//
//  ConversationsListViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate {
    
    var chats = [ConversationModel(name: "Ronald Robertson", message: "Did you forget to place an order?", date: Calendar.current.date(byAdding: .weekday, value: -1, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
                  ConversationModel(name: "Martha Craig", message: "I'm good", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
                  ConversationModel(name: "Arthur Bell", message: "let's go to the cinema?", date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
                  ConversationModel(name: "Edna Castro", message: "Thanks!", date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: true),
                  ConversationModel(name: "Marisela de la Cruse", message: "yeah", date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Stephanie Gilvania", message: "Do you want coffee?", date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
                  ConversationModel(name: "Valery Li", message: "", date: Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Larissa", message: "See you tomorrow!", date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Katie Ha", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
                  ConversationModel(name: "Jane Warren", message: "Sound good", date: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
                  ConversationModel(name: "Irma Flores", message: "I love it", date: Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),
                  ConversationModel(name: "Lola li", message: "WoW!!!", date: Date(), isOnline: true, hasUnreadMessages: true),
                  ConversationModel(name: "Irma Si", message: "I love it", date: Calendar.current.date(byAdding: .minute, value: -6, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
                  ConversationModel(name: "Iren Den", message: "i'm pretty close", date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),
                  ConversationModel(name: "Den Ring", message: "yes, I can", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Ron Braun", message: "", date: Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Ron Kim", message: "👍", date: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Tom Di", message: "lol", date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "Lola Moon", message: "no", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: false),
                  ConversationModel(name: "August Song", message: "Could you lend me a book for the weekend?", date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(), isOnline: false, hasUnreadMessages: true),
                  ConversationModel(name: "April", message: ")))", date: Date(), isOnline: false, hasUnreadMessages: true),
    ]
    
    var groups = [[ConversationModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        createNavigationBar() 
        groups = prepareDataSource()
    }
    private func createNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Join"
        let settingsButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: nil)
        settingsButtonItem.tintColor = .gray
        self.navigationItem.leftBarButtonItem  = settingsButtonItem
    }
    
    private func createTable() {
        let chatTableView = UITableView(frame: view.bounds, style: .plain)
        chatTableView.delegate = self
        chatTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(chatTableView)
        
        let nib = UINib(nibName: ChatCell.className, bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: ChatCell.className)
        chatTableView.dataSource = self
    }
    
    func prepareDataSource() -> [[ConversationModel]] {
        var online = [ConversationModel]()
        var offline = [ConversationModel]()
        for element in chats {
            if element.isOnline == true {
                online.append(element)
            } else {
                offline.append(element)
            }
        }
        return [online, offline]
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "Offline"
        }
    }
    
}

// MARK: - Table view data source

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.className, for: indexPath) as? ChatCell else {
            preconditionFailure("ChatCell can't to dequeued")
        }
        let model = groups[indexPath.section][indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}


