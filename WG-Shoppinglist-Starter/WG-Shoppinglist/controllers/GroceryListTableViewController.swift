//
//  GroceryListTableViewController.swift
//  WG-Shoppinglist
//
//  Created by Christian Schneeweiss on 15.06.19.
//  Copyright © 2019 Christian Schneeweiss. All rights reserved.
//

import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [GroceryItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    #warning("Item Referenz hier einfügen")
    #warning("Online Referenz hier einfügen")
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        user = User(uid: "idid", email: "mc@hagenberg.at")
        
        #warning("Hier das ref.observe(:with:) Code Snippet einfügen")
        
        #warning("Hier den Code für addStateDidChangeListener einfügen")
        
        #warning("Hier den Code für die Online Benutzer Anzahl einfügen")
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
        toggleCellCheckbox(cell, item: groceryItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        #warning("Ganzen Inhalt ersetzen um Items von Firebase zu löschen")
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("Hier den Code mit dem zum Checken ersetzen")
        items[indexPath.row].completed.toggle()
        tableView.reloadData()
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, item: GroceryItem) {
        if !item.completed {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    // MARK: Add Item
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        #warning("Diese saveAction ersetzen")
        let saveAction = UIAlertAction(title: "Save",
           style: .default) { _ in
            let textField = alert.textFields![0]
            
            let groceryItem = GroceryItem(name: textField.text!,
                                          addedByUser: self.user.email,
                                          completed: false)
            
            self.items.append(groceryItem)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
}

