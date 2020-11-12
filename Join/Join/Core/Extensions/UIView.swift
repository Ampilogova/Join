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
    
   public class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
        else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
