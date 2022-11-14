//
//  Country.swift
//  Consolidation 6
//
//  Created by Ákos Morvai on 2022. 05. 04..
//

import UIKit

struct Country: Codable {
    var name: String
    var capital: String
    var flagImageUrl: String
    var population: Int

    init(name: String, capital: String, flagImageUrl: String, population: Int) {
        self.name = name
        self.capital = capital
        self.flagImageUrl = flagImageUrl
        self.population = population
    }
}
