//
//  CardCell.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 10..
//

import UIKit

protocol CardCell: UICollectionViewCell {
    var contentHidden: Bool { get set }
    var card: Card { get set }
    
    func setup(with card: Card)
    
    func clear()
}
