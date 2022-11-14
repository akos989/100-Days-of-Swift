//
//  ViewController.swift
//  Consolidation 2
//
//  Created by Ákos Morvai on 2022. 03. 21..
//

import UIKit

class ViewController: UITableViewController {
    
    let countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Coutries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.imageView?.layoutMargins.top = 4
        cell.imageView?.layer.borderWidth = 1
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
