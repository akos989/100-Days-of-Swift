//
//  ViewController.swift
//  Project2
//
//  Created by Ákos Morvai on 2022. 03. 10..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
    var numberOfQuestions = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in [button1, button2, button3] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        countries.append(contentsOf: ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreButtonTapped))
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
        
        askQuestion()
    }

    func askQuestion(alertAction: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        for (index, button) in [button1, button2, button3].enumerated() {
            button?.setImage(UIImage(named: countries[index]), for: .normal)
        }
        
        title = "\(countries[correctAnswer].uppercased()) - score: \(score)/\(numberOfQuestions)"
        numberOfQuestions += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong answer! That's the flag of \(countries[sender.tag])"
            score -= 1
        }
        
        var message = "Your score is \(score)"
        var actionTitle = "Continue"
        if numberOfQuestions == 10 {
            message = "Your final score is \(score)"
            actionTitle = "Restart"
            numberOfQuestions = 0
            if score > highScore {
                newHighScore()
            }
            score = 0
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    @objc func scoreButtonTapped() {
        let ac = UIAlertController(title: "Current score", message: "Your current score is \(score)", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func newHighScore() {
        let ac = UIAlertController(title: "New high score: \(score)", message: "Your previous highest score was \(highScore) ", preferredStyle: .alert)
        highScore = score
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self] _ in
            self?.saveHighScore()
        })
        present(ac, animated: true)
    }
    
    private func saveHighScore() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
    }
}
