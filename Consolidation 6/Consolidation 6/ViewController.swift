//
//  ViewController.swift
//  Consolidation 6
//
//  Created by Ákos Morvai on 2022. 05. 04..
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries list"
        
        fetchData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else { return }
        detailView.country = countries[indexPath.row]
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    private func fetchData() {
        if let countriesUrl = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let countriesData = try? Data(contentsOf: countriesUrl) {
                do {
                    let jsonCountries = try JSONDecoder().decode([Country].self, from: countriesData)
                    countries = jsonCountries
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            } else {
                print("DAta error")
            }
        } else {
            print("Could not load bundle")
        }
    }
}
