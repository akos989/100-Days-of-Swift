//
//  ImageCardCell.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 10..
//

import UIKit

class ImageCardCell: UICollectionViewCell, CardCell {

    @IBOutlet var imageView: UIImageView!
    
    var contentHidden = true {
        didSet {
            imageView.isHidden = contentHidden
        }
    }
    
    var card: ImageCard?
    
    func setup(with card: Card) {
        guard let imageCard = card as? ImageCard else { fatalError("Not an imagecard passed") }
        self.card = imageCard
//        wordLabel.text = card.word
    }
    
    func clear() {
        contentHidden = true
//        parentBackgroundView.layer.backgroundColor = UIColor.white.cgColor
    }
}
