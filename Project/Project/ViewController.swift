//
//  ViewController.swift
//  Project
//
//  Created by Ákos Morvai on 2022. 03. 07..
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        let defaults = UserDefaults.standard
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(Picture(name: item, openNumber: defaults.integer(forKey: item)))
            }
        }
        pictures.sort {
            return $0.name < $1.name
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = .red
        cell.detailTextLabel?.text = "Opened \(pictures[indexPath.row].openedNumber) times"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let selectedPicture = pictures[indexPath.row]
            vc.selectedImage = selectedPicture.name
            
            selectedPicture.openedNumber += 1
            saveToUserDefaults(picture: selectedPicture)
            tableView.reloadRows(at: [indexPath], with: .none)
            
            vc.selectedImagePosition = indexPath.row
            vc.totalImageNumber = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func saveToUserDefaults(picture: Picture) {
        let defaults = UserDefaults.standard
        defaults.set(picture.openedNumber, forKey: picture.name)
    }
}
