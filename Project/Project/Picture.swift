//
//  Picture.swift
//  Project
//
//  Created by Ákos Morvai on 2022. 04. 16..
//

import UIKit

class Picture: NSObject {
    var name: String
    var openedNumber: Int
    
    init(name: String, openNumber: Int) {
        self.name = name
        self.openedNumber = openNumber
    }
}
