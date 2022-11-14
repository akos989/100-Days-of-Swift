//
//  DetailViewController.swift
//  Consolidation 6
//
//  Created by Ákos Morvai on 2022. 05. 04..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var capitalName: UILabel!
    @IBOutlet var population: UILabel!
    @IBOutlet var flagImageView: UIImageView!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let country = country {
            title = country.name
            capitalName.text = country.capital
            population.text = "\(country.population) million"
            
            if let url = URL(string: country.flagImageUrl) {
                do {
                    let data = try Data(contentsOf: url)
                    flagImageView.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            }
            flagImageView.layer.cornerRadius = 4
            flagImageView.layer.borderWidth = 0.5
        }
    }
}
