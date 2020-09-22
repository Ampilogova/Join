//
//  ProfileViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/20/20.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userInfoLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var avatarView: UIView!
    @IBOutlet var avatarLabel: UILabel!
    

//    init() {
//        у меня нет идей на этот счет. Точно уверена, что распечатать свойства кнопки не получится. Возможно дело в том, что она еще не создана и ее нельзя инициализировать?
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.makeRounded()
        userNameLabel.text = "Tatiana Ampilogova"
        userInfoLabel.text = "About me"
        avatarLabel.text = firstLetter(name: userNameLabel.text ?? "")
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2.8
        print("viewDidLoad\(editButton.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear\(editButton.frame)")
        //размеры разные. Я думаю дело в том что, во viewDidLoad создаются объекты и размер печается до фактического построения, а во viewDidAppear отображается уже правильная геометрия объектов согласно размеру экрана.
    }
    
    private func firstLetter(name: String) -> String {
        let fullName = name
        let full: [String] = fullName.components(separatedBy: " ")
        guard let first = full[0].first else { return "" }
        guard let last = full[1].first else { return "" }
        return String(first) + String(last)
    }
    
    @IBAction func setupAvatar(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        })
        let selectPhoto = UIAlertAction(title: "Select", style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        })
        let takePhoto = UIAlertAction(title: "Take phoro", style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(selectPhoto)
        alertController.addAction(takePhoto)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarButton.setImage(pickedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
