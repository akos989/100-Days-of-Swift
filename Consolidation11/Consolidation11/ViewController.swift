//
//  ViewController.swift
//  Consolidation11
//
//  Created by Ákos Morvai on 2022. 08. 09..
//

import UIKit

class ViewController: UICollectionViewController {
    var cards = [
        WordCard(theme: "Paris", word: "Eiffel Tower"), WordCard(theme: "Paris", word: "Mona Lisa"),
        ImageCard(theme: "Rome", imagePath: "Pope"), ImageCard(theme: "Rome", imagePath: "Colosseum"),
        WordCard(theme: "Budapest", word: "Danube River"), WordCard(theme: "Budapest", word: "Hero's Square"),
        WordCard(theme: "Vienna", word: "Xmas markets"), ImageCard(theme: "Vienna", imagePath: "Prado"),
        WordCard(theme: "Munich", word: "October fest"), ImageCard(theme: "Munich", imagePath: "Sausage"),
        ImageCard(theme: "London", imagePath: "The Shard"), ImageCard(theme: "London", imagePath: "Tower Bridge"),
        WordCard(theme: "New York", word: "The Big Apple"), ImageCard(theme: "New York", imagePath: "Empire State Building"),
        WordCard(theme: "Valencia", word: "Oceanographic Museum"), ImageCard(theme: "Valencia", imagePath: "Cabanyal")
    ]
    
    var selectedCells = [CardCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        cards.shuffle()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.item]
        
        guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: card.getCardCellIdentifier(), for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue \(card.getCardCellIdentifier())")
        }
        cardCell.setup(with: card)

//        cardCell.contentHidden = true

//        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Card", for: indexPath)
        return cardCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCells.count < 2 {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CardCell else { fatalError("Unable to cast cell to CardCell") }
            
            if selectedCells.contains(where: <#T##(CardCell) throws -> Bool#>) {
                selectedCell.contentHidden = true
                selectedCells.removeAll()
            } else {
                selectedCell.contentHidden = false
                selectedCells.append(selectedCell)
            }
            
            if selectedCells.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.checkMatchingCards()
                }
            }
        }
    }
    
    func checkMatchingCards() {
        guard let firstCard = selectedCells[0].card,
              let secondCard = selectedCells[1].card else {
              selectedCells.forEach { cardCell in
                  cardCell.contentHidden = true
              }
              selectedCells.removeAll()
              return
        }
        
        if firstCard.hasSameTheme(like: secondCard) {
            selectedCells.forEach { cardCell in
                cardCell.clear()
            }
        } else {
            selectedCells.forEach { cardCell in
                cardCell.contentHidden = true
            }
        }
        selectedCells.removeAll()
    }
}

