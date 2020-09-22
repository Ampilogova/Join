//
//  UIView.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/20/20.
//

import UIKit

extension UIView {
    
    public  func makeRounded() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
}
