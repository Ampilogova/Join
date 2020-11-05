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
    
//    func saveContext(data: Data, name: String, info: String, completion: @escaping (Error?) -> Void) {
//        let imageInstance = Image(context: context)
//        imageInstance.img = data
//        do {
//            try context.save()
//            print("Data is saved")
//        } catch {
//            completion(error)
//            print(error.localizedDescription)
//        }
//    }
    
//    func fetchImage() -> [Image] {
//        var fetchingImage = [Image]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
//        do {
//            fetchingImage = try context.fetch(fetchRequest) as! [Image]
//        } catch {
//            print("Error while fetching the image")
//        }
//
//        return fetchingImage
//    }
    
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
    func saveContext() {
        do {
            try context.save()
            print("Profile is saved")
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
