//
//  ActionViewController.swift
//  Extension
//
//  Created by Ákos Morvai on 2022. 05. 26..
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    var scriptText = ""
    
    var pageURL = ""

    var currentWebPageScripts = [Script]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        script.text = scriptText
    }
    
    func runScript() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": scriptText]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

    @objc func done() {
        if !script.text.isEmpty {
            let ac = UIAlertController(title: "Save script", message: "Do you want to save the script for this page?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes, run and save", style: .default) {
                [weak self] _ in
                if let scriptText = self?.script.text,
                   let pageUrl = self?.pageURL,
                   let url = URL(string: pageUrl),
                   let urlHost = url.host,
                   var currentWebPageScripts = self?.currentWebPageScripts {
                    currentWebPageScripts.append(Script(name: "code name", code: scriptText))
                    UserDefaults.standard.set(currentWebPageScripts, forKey: urlHost)
                } else {
                    print("Could not save script!")
                }
                
                self?.runScript()
            })
            ac.addAction(UIAlertAction(title: "No, only run", style: .destructive) {
                [weak self] _ in
                self?.runScript()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Empty script", message: "Script cannot be empty", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}
