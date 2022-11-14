//
//  ListTableViewController.swift
//  Project 4
//
//  Created by Ákos Morvai on 2022. 03. 24..
//

import UIKit

class ListTableViewController: UITableViewController {
    var websites = ["google.com", "apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewViewController {
            vc.websites = websites
            vc.initialWebsite = websites[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
