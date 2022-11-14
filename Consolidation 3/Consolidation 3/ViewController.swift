//
//  ViewController.swift
//  Consolidation 3
//
//  Created by Ákos Morvai on 2022. 03. 27..
//

import UIKit

class ViewController: UITableViewController {
    var shoppingListItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(createNewList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addIconPushed))
        
        createNewList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingListItems[indexPath.row]
        return cell
    }
    
    @objc func createNewList() {
        let ac = UIAlertController(title: "New list title", message: "Write the name of your new shopping list!", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let listTitle = ac?.textFields?[0].text, listTitle != "" else { return }
            self?.title = listTitle
            self?.shoppingListItems = []
            self?.tableView.reloadData()
        }
        submitAction.isEnabled = false
        ac.addAction(submitAction)
        if let title = self.title, !title.isEmpty {
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        
        ac.addTextField {
            [weak self, weak submitAction] textField in
            if let submitAction = submitAction {
                self?.disableAlertActionOnTextFieldChange(textField, submitAction)
            }
        }
        
        present(ac, animated: true)
    }
    
    @objc func addIconPushed() {
        let ac = UIAlertController(title: "New item", message: "Add a new shopping list item", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            if let itemName = ac?.textFields?[0].text, itemName != "" {
                self?.addNewItem(itemName)
            }
        }
        submitAction.isEnabled = false
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addTextField {
            [weak self, weak submitAction] textField in
            if let submitAction = submitAction {
                self?.disableAlertActionOnTextFieldChange(textField, submitAction)
            }
        }
        
        present(ac, animated: true)
    }
    
    private func addNewItem(_ itemName: String) {
        shoppingListItems.insert(itemName, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func disableAlertActionOnTextFieldChange(_ textField: UITextField, _ alertAction: UIAlertAction) {
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) {
            [weak textField, weak alertAction] _ in
            if let letterCount = textField?.text?.count, let alertAction = alertAction {
                alertAction.isEnabled = letterCount > 0
            }
        }
    }
}
