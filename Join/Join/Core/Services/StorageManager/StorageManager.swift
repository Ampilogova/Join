//
//  StorageManager.swift
//  Join
//
//  Created by Tatiana Ampilogova on 11/3/20.
//

import UIKit
import CoreData

class StorageManager {
    
    static let shareInstance = StorageManager()
    let context = (UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate).persistentContainer.viewContext
    
    let fetchRequestChannel = NSFetchRequest<Channel>(entityName: "Channel")
    let fetchRequestMessage = NSFetchRequest<Message>(entityName: "Message")
    
    func saveProfile(_ profile: Profile, completion: @escaping (Error?) -> Void) {
        do {
            try context.save()
            completion(nil)
            print("Profile is saved")
        } catch {
            completion(error)
            print(error.localizedDescription)
        }
    }
    
    func deleteChannels() {
        do {
            let channels = try context.fetch(fetchRequestChannel)
            for channel in channels {
                context.delete(channel)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteMessages() {
        do {
            let messages = try context.fetch(fetchRequestMessage)
            for message in messages {
                context.delete(message)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
            print("Context is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchProfile() -> [Profile] {
        var fetchingProfile = [Profile]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do {
            fetchingProfile = try context.fetch(fetchRequest) as! [Profile]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingProfile
    }
}

