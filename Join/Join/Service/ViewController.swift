//
//  ViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 11/5/20.
//

import Foundation
import CoreData

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.reloadData()
    }
}
