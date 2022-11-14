//
//  ViewController.swift
//  Project2
//
//  Created by Ákos Morvai on 2022. 03. 10..
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var numberOfQuestions = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotification()
        scheduleLocalNotifications()
        
        for button in [button1, button2, button3] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        countries.append(contentsOf: ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreButtonTapped))
        
        askQuestion()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func registerNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yayy")
            } else {
                print(":(")
            }
        }
    }
    
    func scheduleLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Play with the game"
        content.body = "Try the be better in the game than last time"
        content.categoryIdentifier = "playAlert"
        content.sound = .defaultCritical
        
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 35
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func askQuestion(alertAction: UIAlertAction! = nil) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            for button in [self.button1, self.button2, self.button3] {
                button!.transform = .identity
            }
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        for (index, button) in [button1, button2, button3].enumerated() {
            button?.setImage(UIImage(named: countries[index]), for: .normal)
        }
        
        title = "\(countries[correctAnswer].uppercased()) - score: \(score)/\(numberOfQuestions)"
        numberOfQuestions += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
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
}
