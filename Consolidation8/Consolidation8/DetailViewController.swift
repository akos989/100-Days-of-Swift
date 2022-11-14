//
//  DetailViewController.swift
//  Consolidation8
//
//  Created by Ákos Morvai on 2022. 06. 15..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var noteTextView: UITextView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        toolbarItems = [deleteButton, spacer, saveButton]
        navigationController?.isToolbarHidden = false
        
        if let note = note {
            noteTextView.text = note.text
            title = note.title
        }
    }
    
    @objc func saveNote() {
        if let note = note {
            note.text = noteTextView?.text ?? ""
            note.date = Date()
            if let savedData = try? JSONEncoder().encode(note) {
                UserDefaults.standard.set(savedData, forKey: note.title)
            }
        }
    }

    
    @objc func deleteNote() {
        if let note = note {
            UserDefaults.standard.removeObject(forKey: note.title)
        }
        navigationController?.popViewController(animated: true)
    }
}
