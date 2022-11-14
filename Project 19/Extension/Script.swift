//
//  Script.swift
//  Extension
//
//  Created by Ákos Morvai on 2022. 05. 27..
//

import UIKit

class Script: NSObject, Codable {
    var name: String
    var code: String
    
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
