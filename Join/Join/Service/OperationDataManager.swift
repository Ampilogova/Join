//
//  OperationDataManager.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/15/20.
//

import UIKit

class SaveDataOperation: Operation {
    
    let data: ProfileModel
    
    init(data: ProfileModel) {
        self.data = data
    }
    
    override func main() {
        let dataName = data.name
        let dataInfo = data.info
        let fileName = self.getDocumentsDirectory().appendingPathComponent("name.txt")
        let fileInfo = self.getDocumentsDirectory().appendingPathComponent("info.txt")
        do {
            try dataName.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
            try dataInfo.write(to: fileInfo, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("failed to write file")
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
                }
            }
            
            do {
                try data.write(to: fileImage)
            } catch let error {
                print("error saving file with error", error)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
}

class OperationDataManager {
    
    var queue = OperationQueue()
    
    func save(data: ProfileModel, completion: @escaping (Error?) -> Void) {
        let operation = SaveDataOperation(data: data)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(nil)
            }
        }
        queue.addOperation(operation)
    }
    
}
