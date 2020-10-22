//
//  Configurable.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/1/20.
//

import Foundation

public protocol ConfigurationView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
