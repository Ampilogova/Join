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
    @IBOutlet var saveGCDButton: UIButton!
    @IBOutlet var avatarContainerView: UIView!
    @IBOutlet var saveOperationButton: UIButton!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userInfoTextView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    let avatarView = AvatarView.fromNib()
    let themeService = ThemeService()
    let gcdManager = GCDDataManager()
    let operationsManager = OperationDataManager()
    var oldModel: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.isUserInteractionEnabled = false
        userInfoTextView.isUserInteractionEnabled = false
        saveGCDButton.isUserInteractionEnabled = false
        saveOperationButton.isUserInteractionEnabled = false
        avatarView.configure(userNameTextField.text ?? "")
        avatarView.avatarButton.addTarget(self, action: #selector(setupAvatar), for: .touchUpInside)
        setupCurrentTheme()
        userNameTextField.delegate = self
        userInfoTextView.delegate = self
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
        
        gcdManager.read { (model) in
            self.userNameTextField.text = model.name
            self.userInfoTextView.text = model.info
            self.avatarView.avatarButton.setImage(model.image, for: .normal)
            self.oldModel = model
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        saveGCDButton.layer.cornerRadius = 16
        saveGCDButton.layer.masksToBounds = true
        saveOperationButton.layer.cornerRadius = 16
        saveOperationButton.layer.masksToBounds = true
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.userNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
    
    func configure(with model: ProfileModel) {
        userNameTextField.text = model.name
        userInfoTextView.text = model.info
        avatarView.avatarButton.setImage(model.image, for: .normal)
    }
    
    private func successSaveAlert() {
        let alert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    enum Source {
        case gcd
        case operation
    }
    private func unsuccessSaveAlert(source: Source) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { [self] _ in
            switch source {
            case .gcd:
                checkAlertGCD()
            case .operation:
                checkAlertOp()
            }
        })
        
        alert.addAction(okAction)
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func checkAlertGCD() {
        activityIndicator.startAnimating()
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        self.view.isUserInteractionEnabled = false
        gcdManager.save(data: model) { (error) in
            self.view.isUserInteractionEnabled = true
            if error == nil {
                self.successSaveAlert()
            } else {
                self.unsuccessSaveAlert(source: .gcd)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    private func checkAlertOp() {
        activityIndicator.startAnimating()
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        self.view.isUserInteractionEnabled = false
        operationsManager.save(data: model) { (error) in
            self.view.isUserInteractionEnabled = true
            if error == nil {
                self.successSaveAlert()
            } else {
                self.unsuccessSaveAlert(source: .operation)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func saveGCD(_ sender: Any) {
        checkAlertGCD()
    }
    
    @IBAction func saveOperation(_ sender: Any) {
        checkAlertOp()
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
}

extension ProfileViewController : UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.userInfoTextView = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.userInfoTextView = textView
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.userNameTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userNameTextField = textField
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        if model != oldModel {
            saveGCDButton.isUserInteractionEnabled = true
            saveOperationButton.isUserInteractionEnabled = true
        } else {
            saveGCDButton.isUserInteractionEnabled = false
            saveOperationButton.isUserInteractionEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let model = ProfileModel(name: userNameTextField.text ?? "", info: userInfoTextView.text, image: avatarView.avatarButton.currentImage)
        if model != oldModel {
            saveGCDButton.isUserInteractionEnabled = true
        } else {
            saveGCDButton.isUserInteractionEnabled = false
        }
        return true
    }
}
