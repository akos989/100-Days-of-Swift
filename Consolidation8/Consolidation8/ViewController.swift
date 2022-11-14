//
//  ViewController.swift
//  Consolidation8
//
//  Created by Ákos Morvai on 2022. 06. 15..
//

import UIKit

class ViewController: UITableViewController {

    var notes = [
        Note(title: "valemi", date: Date(), text: "itt vanalam hosszú szöveg van mert ez egy jegyzet, de ennyi már nem fog szeintem kifénri"),
        Note(title: "asdasd", date: Date(), text: "itt vanalam hosszú szöveg van mert ez egy jegyzet, de ennyi már nem fog szeintem kifénri"),
        Note(title: "asdasd asdas", date: Date(), text: "ntem kifénri"),
        Note(title: "asd", date: Date(), text: "itt vfog szeintem kifénri"),
        Note(title: "1212", date: Date(), text: "itt vanalam hosszú szöveg van mert ez egy jegyzet, de ennyi már nem fog szeintem kifénri")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue NoteTableViewCell.")
        }
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: note.date)
        cell.noteTextLabel.text = note.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? DetailViewController else { return }
        vc.note = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addNewNote() {
        let ac = UIAlertController(title: "New note", message: "Write the title of the new note", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak ac] _ in
            if let noteTitle = ac?.textFields?[0].text {
                <#statements#>
            }
        }))
    }

}

