//
//  Note.swift
//  Consolidation8
//
//  Created by Ákos Morvai on 2022. 06. 15..
//

import Foundation

class Note: Codable {
    init(title: String, date: Date, text: String) {
        self.title = title
        self.date = date
        self.text = text
    }
    
    var title: String
    var date: Date
    var text: String
}
