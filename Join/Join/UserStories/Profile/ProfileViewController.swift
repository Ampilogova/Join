//
//  ProfileViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/20/20.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConfigurationView {
    
    typealias ConfigurationModel = ProfileModel
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var avatarContainerView: UIView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userInfoTextView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let avatarView = AvatarView.fromNib()
    let themeService = ThemeService()
    let gcdManager = GCDDataManager()
    var oldModel: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.avatarButton.addTarget(self, action: #selector(setupAvatar), for: .touchUpInside)
        saveButton.isUserInteractionEnabled = false
        setupCurrentTheme()
        tapGR()
        fetchImage()
        setupFields()
    }
    
    func fetchImage() {
        let fetchProfile = StorageManager.shareInstance.fetchProfile()
        avatarView.configure(userNameTextField.text ?? "")
        if let imageData = fetchProfile.last?.image?.img {
            avatarView.avatarButton.setImage(UIImage(data: imageData), for: .normal)
        }
    }
    
    func setupFields() {
        userNameTextField.isUserInteractionEnabled = false
        userInfoTextView.isUserInteractionEnabled = false
        userNameTextField.delegate = self
        userInfoTextView.delegate = self
        let fetchProfile = StorageManager.shareInstance.fetchProfile()
        if !fetchProfile.isEmpty {
            userNameTextField.text = fetchProfile.last?.name
            userInfoTextView.text = fetchProfile.last?.aboutUser
        } else {
            userNameTextField.placeholder = "Name"
            userInfoTextView.text = "about you"
        }
    }
    
    func setupCurrentTheme() {
        view.backgroundColor = themeService.currentTheme().backgroundColor
        userNameTextField.textColor = themeService.currentTheme().textColor
        userNameTextField.backgroundColor = themeService.currentTheme().backgroundColor
        userInfoTextView.backgroundColor = themeService.currentTheme().backgroundColor
        userInfoTextView.textColor = themeService.currentTheme().textColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.userNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configure(with model: ProfileModel) {
        userNameTextField.text = model.name
        userInfoTextView.text = model.info
        avatarView.avatarButton.setImage(model.image, for: .normal)
    }
    // MARK: - Actions
    
    @IBAction func editAction(_ sender: Any) {
        userNameTextField.isUserInteractionEnabled = true
        userInfoTextView.isUserInteractionEnabled = true
        userNameTextField.borderStyle = .roundedRect
        userInfoTextView.layer.borderWidth = 1
        userInfoTextView.layer.borderColor = UIColor.customGray.cgColor
        userInfoTextView.layer.cornerRadius = 8
        userInfoTextView.layer.masksToBounds = true
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
    
    private func successSaveAlert() {
        let alert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func unsuccessSaveAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { [self] _ in
            checkAlert()
        })
        
        alert.addAction(okAction)
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func checkAlert() {
        activityIndicator.startAnimating()
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        let newModel = Profile(context: StorageManager.shareInstance.context)
        newModel.name = model.name
        newModel.aboutUser = model.info
        if let imageData = model.image?.pngData() {
            newModel.image = Image(context: StorageManager.shareInstance.context)
            newModel.image?.img = imageData
        }
        StorageManager.shareInstance.saveProfile(newModel) { (error) in
            if error == nil {
                self.successSaveAlert()
            } else {
                self.unsuccessSaveAlert()
            }
        }
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        checkAlert()
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
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        var moveUp = false
        
        if let userInfoTextView = userInfoTextView {
            let bottomOfTextView = userInfoTextView.convert(userInfoTextView.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextView > topOfKeyboard {
                moveUp = true
            }
        }
        if(moveUp) {
            self.view.frame.origin.y = (0 - keyboardSize.height) + 25
        }
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    func tapGR() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
    }
}

extension ProfileViewController : UITextViewDelegate, UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        if model.name != oldModel?.name || model.info != oldModel?.info || model.image != oldModel?.image {
            saveButton.isUserInteractionEnabled = true
        } else {
            saveButton.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        if model.name != oldModel?.name || model.info != oldModel?.info || model.image != oldModel?.image {
            saveButton.isUserInteractionEnabled = true
        } else {
            saveButton.isUserInteractionEnabled = false
        }
    }
}
