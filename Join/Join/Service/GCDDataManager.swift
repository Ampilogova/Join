//
//  GCDDataManager.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/15/20.
//

import UIKit

class GCDDataManager {
    
    func save(data: ProfileModel, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            let dataName = data.name
            let dataInfo = data.info
            let fileName = self.getDocumentsDirectory().appendingPathComponent("name.txt")
            let fileInfo = self.getDocumentsDirectory().appendingPathComponent("info.txt")
            do {
                try dataName.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
                try dataInfo.write(to: fileInfo, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("failed to write file")
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            if data.image != nil {
                let dataImage = data.image
                let fileImage = self.getDocumentsDirectory().appendingPathComponent("fileImage.png")
                guard let data = dataImage?.jpegData(compressionQuality: 1) else { return }
                if FileManager.default.fileExists(atPath: fileImage.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileImage.path)
                    } catch let removeError {
                        print("error", removeError)
                        DispatchQueue.main.async {
                            completion(removeError)
                            return
                        }
                    }
                }
                
                do {
                    try data.write(to: fileImage)
                } catch let error {
                    print("error saving file with error", error)
                    DispatchQueue.main.async {
                        completion(error)
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func read(completion: @escaping (ProfileModel) -> Void) {
        DispatchQueue.global().async {
            let filepath = self.getDocumentsDirectory().appendingPathComponent("name.txt")
            let fileInfo = self.getDocumentsDirectory().appendingPathComponent("info.txt")
            let fileImage = self.getDocumentsDirectory().appendingPathComponent("fileImage.png")
            do {
                let dataName = try NSString(contentsOf: filepath,
                                            encoding: String.Encoding.ascii.rawValue)
                let dataInfo = try NSString(contentsOf: fileInfo,
                                            encoding: String.Encoding.ascii.rawValue)
                let dataImage = (try? Data(contentsOf: fileImage)) ?? Data()
                let model = ProfileModel(name: dataName as String, info: dataInfo as String, image: UIImage(data: dataImage))
                DispatchQueue.main.async {
                    completion(model)
                }
            } catch {
                print("failed to read file")
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
}
