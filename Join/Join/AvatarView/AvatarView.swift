//
//  AvatarView.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import UIKit

class AvatarView: UIView {
    
    @IBOutlet var avatarLabel: UILabel!
    @IBOutlet var avatarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func firstLetter(name: String) -> String {
        let components = name.components(separatedBy: " ")
        if components.count == 0 {
            return ""
        } else if components.count == 1 {
            let first = components[0].first
            return String(first ?? " ")
        } else {
            let first = components[0].first
            let last = components[1].first
            return String(first ?? " ") + String(last ?? " ")
        }
    }
    
    func configure(_ name: String) {
        avatarLabel.text = firstLetter(name: name)
    }
    
    func configure(_ image: UIImage) {
        avatarButton.setImage(image, for: .normal)
    }
}
