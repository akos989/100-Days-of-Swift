//
//  Card.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 09..
//

import UIKit

class Card: NSObject {
    let theme: String
    
    init(theme: String) {
        self.theme = theme
    }
    
    func hasSameTheme(like otherCard: Card) -> Bool {
        return self.theme == otherCard.theme
    }
    
    func getCardCellIdentifier() -> String {
        return "Word Card"
    }
}
