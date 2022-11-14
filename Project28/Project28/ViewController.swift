//
//  ViewController.swift
//  Project28
//
//  Created by Ákos Morvai on 2022. 07. 22..
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
            
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
        
        if !checkPasswordIsSet() {
            createPassword()
        }
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authenticate failed", message: "You could not be verified, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            if checkPasswordIsSet() {
                let ac = UIAlertController(title: "Biometry unavailable", message: "Please provide your previously set password", preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Login", style: .default) { [weak self, weak ac] _ in
                    if let text = ac?.textFields?[0].text {
                        if let password = KeychainWrapper.standard.string(forKey: "Password") {
                            if password.elementsEqual(text) {
                                self?.unlockSecretMessage()
                            }
                        }
                    }
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
            } else {
                createPassword()
            }
        }
    }
    
    func checkPasswordIsSet() -> Bool {
        if let hasPassword = KeychainWrapper.standard.bool(forKey: "HasPassword"),
           hasPassword == true {
            return true
        }
        return false
    }
    
    func createPassword() {
        let ac = UIAlertController(title: "Create password", message: "Add a password if you cannot use biometrics", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak ac] _ in
            if let text = ac?.textFields?[0].text,
               !text.isEmpty {
                KeychainWrapper.standard.set(text, forKey: "Password")
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
                
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = nil
    }
    
    @objc func saveSecretMessage() {
        guard !secret.isHidden else {
            return
        }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder() // makes the textview stop being active on the screen
        secret.isHidden = true
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
}
