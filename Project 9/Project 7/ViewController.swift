//
//  ViewController.swift
//  Project 7
//
//  Created by Ákos Morvai on 2022. 03. 29..
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Source", style: .plain, target: self, action: #selector(showDataSource))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitionsTapped))
        
        performSelector(inBackground: #selector(fetchPetitions), with: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fetchPetitions() {
        let urlString: String
//        if navigationController?.tabBarItem.tag == 0 {
//            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//        }
        
        if let url = URL(string: urlString) {
            do {
                let data = try Data(contentsOf: url)
                parse(json: data)
            } catch {
                performSelector(onMainThread: #selector(showAlert), with: nil, waitUntilDone: false)
            }
        }
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadRows), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showAlert), with: nil, waitUntilDone: false)
        }
    }

    @objc func showAlert() {
        let ac = UIAlertController(title: "Loading error", message: "There was a loading error, try again!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showDataSource() {
        let ac = UIAlertController(title: "Data source", message: "Data the is coming from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitionsTapped() {
        let ac = UIAlertController(title: "Filter petitions", message: "Search for a word in the listed petitions", preferredStyle: .alert)
        
        ac.addTextField()
        if !filterString.isEmpty {
            ac.textFields?[0].text = filterString
            ac.addAction(UIAlertAction(title: "Delete filter", style: .destructive) {
                [weak self] _ in
                self?.filterString = ""
                self?.performSelector(inBackground: #selector(self?.filterPetitions), with: nil)
                self?.filterPetitions()
            })
        }
        ac.addAction(UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            if let filterWord = ac?.textFields?[0].text {
                self?.filterString = filterWord
                self?.performSelector(inBackground: #selector(self?.filterPetitions), with: nil)
            }
        })
        
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        if filterString.isEmpty {
            filteredPetitions = petitions
        } else {
            filteredPetitions = petitions.filter { petition in
                return petition.title.lowercased().contains(filterString.lowercased())
            }
        }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
}
