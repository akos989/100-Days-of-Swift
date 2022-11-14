//
//  CardCell.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 09..
//

import UIKit

class WordCardCell: UICollectionViewCell, CardCell {
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var parentBackgroundView: UIView!
    
    var contentHidden = true {
        didSet {
            wordLabel.isHidden = contentHidden
        }
    }
    
    var card: WordCard?
    
    func setup(with card: Card) {
        guard let wordCard = card as? WordCard else { fatalError("Not an wordcard passed") }
        self.card = wordCard
        wordLabel.text = wordCard.word
    }
    
    func clear() {
        contentHidden = true
        parentBackgroundView.layer.backgroundColor = UIColor.white.cgColor
    }
}
