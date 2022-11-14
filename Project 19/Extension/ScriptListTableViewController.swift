//
//  ScriptListTableViewController.swift
//  Extension
//
//  Created by Ákos Morvai on 2022. 05. 27..
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ScriptListTableViewController: UITableViewController {
    var pageTitle = ""
    var pageURL = ""

    let defaultScripts = [
        Script(name: "Show alert", code: "alert('Hello world!');"),
        Script(name: "Turn background to red", code: "document.body.style.backgroundColor = \"red\";"),
        Script(name: "Navigate to Apple.com", code: "window.location.href = 'https://apple.com';")
    ]
    var currentWebPageScripts = [Script]()
    var allScripts: [Script] {
        defaultScripts + currentWebPageScripts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = inputItem.attachments?.first {
            itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) {
                [weak self] (dict, error) in
                guard let itemDictionary = dict as? NSDictionary,
                      let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                
                if let pageUrl = self?.pageURL,
                   let url = URL(string: pageUrl),
                   let host = url.host {
                    if let scriptDictionary = UserDefaults.standard.object(forKey: host) as? [Script] {
                        self?.currentWebPageScripts = scriptDictionary
                    }
                }
                
                DispatchQueue.main.async {
                    self?.title = self?.pageTitle
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allScripts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)

        cell.textLabel?.text = allScripts[indexPath.row].name
        cell.detailTextLabel?.text = String(allScripts[indexPath.row].code.prefix(15))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ScriptDetail") as? ActionViewController {
            vc.currentWebPageScripts = currentWebPageScripts
            vc.pageURL = pageURL
            vc.scriptText = allScripts[indexPath.row].code
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
