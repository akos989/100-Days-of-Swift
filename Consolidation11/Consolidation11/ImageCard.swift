//
//  ImageCard.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 10..
//

import UIKit

class ImageCard:  Card {
    let imagePath: String
    
    init(theme: String, imagePath: String) {
        self.imagePath = imagePath
        super.init(theme: theme)
    }
    
    override func getCardCellIdentifier() -> String {
        return "Image Card"
    }
}
