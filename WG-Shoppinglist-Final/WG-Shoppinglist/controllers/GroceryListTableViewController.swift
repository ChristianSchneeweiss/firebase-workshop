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
    let ref = Database.database().reference(withPath: "grocery-items")
    #warning("Online Referenz hier einfügen")
    let usersRef = Database.database().reference(withPath: "online")
    
    
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
        ref.observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot) {
                    newItems.append(groceryItem)
                }
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        #warning("Hier den Code für addStateDidChangeListener einfügen")
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            #warning("Code zum Speichern des Benutzer einfügen")
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        #warning("Hier den Code für die Online Benutzer Anzahl einfügen")
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                self.userCountBarButtonItem?.title = "0"
            }
        })
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
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("Hier den Code mit dem zum Checken ersetzen")
        let groceryItem = items[indexPath.row]
        let toggledCompletion = !groceryItem.completed
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
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
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            let groceryItem = GroceryItem(name: text,
                                          addedByUser: self.user.email,
                                          completed: false)
            
            let groceryItemRef = self.ref.child(text.lowercased())
            
            groceryItemRef.setValue(groceryItem.toAnyObject())
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

