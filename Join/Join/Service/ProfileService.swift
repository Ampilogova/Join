//
//  ProfileService.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/13/20.
//

import UIKit

class ProfileService {
    
    let userDefaults = UserDefaults.standard
    
    
    func saveUserData(profile: ProfileModel) {
        userDefaults.set(profile.name, forKey: "name")
        userDefaults.set(profile.info, forKey: "info")
        userDefaults.set(profile.image, forKey: "image")
    }
    
    func setupUserData() -> ProfileModel? {
        guard let name = userDefaults.string(forKey: "name"),
              let info = userDefaults.string(forKey: "info") else { return nil}
        return ProfileModel(name: name, info: info, image: UIImage())
    }
}
