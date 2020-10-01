//
//  ProfileViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/20/20.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userInfoLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var avatarContainerView: UIView!
    
    let avatarView = AvatarView.fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = "Tatiana Ampilogova"
        userInfoLabel.text = "About me"
        avatarView.configure(userNameLabel.text ?? "")
        avatarView.avatarButton.addTarget(self, action: #selector(setupAvatar), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarContainerView.makeRounded()
        avatarContainerView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor),
            avatarView.topAnchor.constraint(equalTo: avatarContainerView.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor)
        ])
        saveButton.layer.cornerRadius = 16
        saveButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func setupAvatar(_ sender: Any) {
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
        alertController.addAction(cancelAction)
        alertController.addAction(selectPhoto)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhoto = UIAlertAction(title: "Take phoro", style: .default, handler: { _ in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(takePhoto)
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarView.configure(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
