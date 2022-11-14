//
//  ViewController.swift
//  Project 5
//
//  Created by Ákos Morvai on 2022. 03. 24..
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let words = try? String(contentsOf: startWordsURL) {
            allWords = words.components(separatedBy: "\n")
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        if let savedTitle = defaults.string(forKey: "title"),
           let savedWords = defaults.object(forKey: "usedWords") as? [String] {
            title = savedTitle
            usedWords = savedWords
            
            let indexPathArray = [Int](0..<usedWords.count).map { index in
                return IndexPath(row: index, section: 0)
            }
            tableView.insertRows(at: indexPathArray, with: .automatic)
        } else {
            restartGame()
        }
    }
    
    @objc func restartGame() {
        title = allWords.randomElement()
        UserDefaults.standard.set(title, forKey: "title")
        UserDefaults.standard.set([], forKey: "usedWords")
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promtForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer, onError: showErrorMessage) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    UserDefaults.standard.set(usedWords, forKey: "usedWords")
                    return
                } else {
                    showErrorMessage(title: "Not a valid word", message: "\(answer) is not a real English word!")
                }
            } else {
                showErrorMessage(title: "Already used", message: "Cannot use the same word twice!")
            }
        }
    }
    
    func isPossible(word: String, onError: (String, String) -> Void) -> Bool {
        guard var tempWord = title?.lowercased() else {
            onError("Somethings is wrong", "Something went wrong during reading the original word, try to refresh the app.")
            return false
        }
        guard word.count >= 3 else {
            onError("Too short", "The answer has to be longer than 2 characters!")
            return false
        }
        guard word != tempWord else {
            onError("Same as original", "The answer cannot be the same as the original word!")
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                onError("Invalid characters", "The answer cannot contain characters outside the orignal word!")
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains() {
            return word == $0.lowercased()
        }
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
