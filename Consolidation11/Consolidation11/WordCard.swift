//
//  WordCard.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 10..
//

import UIKit

class WordCard: Card {
    let word: String
    
    init(theme: String, word: String) {
        self.word = word
        super.init(theme: theme)
    }
    
    override func getCardCellIdentifier() -> String {
        return "Word Card"
    }
}
