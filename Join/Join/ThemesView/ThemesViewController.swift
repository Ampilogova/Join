//
//  ThemesViewController.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/7/20.
//

import UIKit

class ThemesViewController: UIViewController, ChatThemeViewDelegate {
    
    let themeService = ThemeService()
    
    public var selectedTheme: ((ThemeModel) -> ())?
    
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.backgroundColor = .clear
        createNavigationBar()
        setupThemesViews()
        didSelectTheme(theme: themeService.currentTheme())
        view.backgroundColor = themeService.currentTheme().backgroundColor
    }
    
    func setupThemesViews() {
        let themes = themeService.allThemes()
        for theme in themes {
            let themeView = ChatThemeView.fromNib()
            stackView?.addArrangedSubview(themeView)
            themeView.configure(with: theme)
            themeView.delegate = self
        }
        stackView?.addArrangedSubview(UIView())
    }
    
    private func createNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Settings"
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(cancel))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func didSelectTheme(theme: ThemeModel) {
        for view in stackView.arrangedSubviews {
            if let themeView = view as? ChatThemeView {
                if themeView.model?.name == theme.name {
                    themeView.themeView.layer.borderColor = UIColor.blue.cgColor
                    themeView.themeView.layer.borderWidth = 4
                    self.view.backgroundColor = theme.backgroundColor
                } else {
                    themeView.themeView.layer.borderColor = UIColor.gray.cgColor
                    themeView.themeView.layer.borderWidth = 1
                }
                selectedTheme?(theme)
                themeView.themeLabel.textColor = theme.textColor
            }
        }
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        print("ChatThemeViewDelegate deinit")
    }
}
