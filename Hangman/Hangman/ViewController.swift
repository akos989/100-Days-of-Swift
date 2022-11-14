//
//  ViewController.swift
//  Hangman
//
//  Created by Ákos Morvai on 2022. 04. 04..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var guessWordLabel: UILabel!
    @IBOutlet var wrongLettersLabel: UILabel!
    @IBOutlet var tryCharacterButton: UIButton!
    @IBOutlet var characterInputField: UITextField!
    
    var wordList = [String]()
    var guessWord = ""
    var lifeRemaining = 7
    var wrongLetters = [Character]()
    var foundLetters = [Character]() {
        didSet {
            guard !foundLetters.isEmpty else {
                guessWordLabel.text = String(repeating: "?", count: guessWord.count)
                return
            }
            let lastCharacter = foundLetters.last!
            if var guessWordLabelText = guessWordLabel.text {
                for (index, letter) in guessWord.enumerated() {
                    if letter == lastCharacter {
                        let indexInWord = guessWordLabelText.index(guessWordLabelText.startIndex, offsetBy: index)
                        guessWordLabelText.replaceSubrange(indexInWord...indexInWord, with: String(lastCharacter))
                    }
                }
                guessWordLabel.text = guessWordLabelText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(hintTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newGameTapped))
        
        fetchWordList()
        initNewGame()
    }
    
    func fetchWordList() {
        if let wordFileUrl = Bundle.main.url(forResource: "words", withExtension: "txt"),
           let words = try? String(contentsOf: wordFileUrl) {
                wordList = words.components(separatedBy: "\n")
        } else {
            wordList = ["tree"]
        }
    }
    
    func initNewGame() {
        guessWord = wordList.randomElement() ?? wordList[0]
        guessWordLabel.text = String(repeating: "?", count: guessWord.count)
        lifeRemaining = 7
        wrongLetters = []
    }
    
    @objc func newGameTapped() {
        
    }
    
    @objc func hintTapped() {
        let ac = UIAlertController(title: "Hint", message: "The word is \(guessWord)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func tryButtonTapped(_ sender: UIButton) {
        guard let newLetterString = characterInputField.text,
              newLetterString.count == 1,
              let newLetter = newLetterString.first else { return }
        
        if guessWord.contains(newLetter) {
            if let guessWordLabelText = guessWordLabel.text,
               guessWordLabelText.contains(newLetter) {
                // already found
            }
            foundLetters.append(newLetter)
        } else {
            wrongLetters.append(newLetter)
            // new in wrong letter list
            // life -= 1
            // already in wrong letter list
        }
    }
}
