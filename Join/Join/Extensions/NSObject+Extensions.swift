//
//  NSObject+Extensions.swift
//  Join
//
//  Created by Tatiana Ampilogova on 9/29/20.
//

import Foundation

extension NSObject {

    public var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }

    public static var className: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
}
