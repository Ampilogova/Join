//
//  ChatThemeView.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/7/20.
//

import UIKit

protocol ChatThemeViewDelegate: class {
    func didSelectTheme(theme: ThemeModel)
}

class ChatThemeView: UIView, ConfigurationView {
    
    @IBOutlet var themeContainerView: UIView!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var themeView: UIView!
    @IBOutlet var incomingThemeView: UIView!
    @IBOutlet var outgoingThemeView: UIView!
    weak var delegate: ChatThemeViewDelegate?
    
    var model: ThemeModel?
    typealias ConfigurationModel = ThemeModel
    let themeService = ThemeService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        incomingThemeView.layer.cornerRadius = 8
        incomingThemeView.layer.masksToBounds = true
        outgoingThemeView.layer.cornerRadius = 8
        outgoingThemeView.layer.masksToBounds = true
        themeView.layer.cornerRadius = 10
        themeView.layer.masksToBounds = true
        themeView.layer.borderColor = UIColor.gray.cgColor
        themeView.layer.borderWidth = 1
        themeContainerView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: AnyObject) {
        guard let model = model else { return }
        delegate?.didSelectTheme(theme: model)
    }
    
    func configure(with model: ThemeModel) {
        self.model = model
        themeLabel.text = model.name
        themeView.backgroundColor = model.backgroundColor
        incomingThemeView.backgroundColor = model.incoming
        outgoingThemeView.backgroundColor = model.outgoing
    }
    
    deinit {
        print("ChatThemeViewDelegate deinit")
    }
}
