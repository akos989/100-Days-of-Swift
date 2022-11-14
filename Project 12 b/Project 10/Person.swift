//
//  Person.swift
//  Project 10
//
//  Created by Ákos Morvai on 2022. 04. 11..
//

import UIKit

class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
