//
//  Picture.swift
//  Consolidation 5
//
//  Created by Ákos Morvai on 2022. 04. 17..
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var imageURL: String
    var liked: Bool
    
    init(name: String, imageURL: String, liked: Bool = false) {
        self.name = name
        self.imageURL = imageURL
        self.liked = liked
    }
}
