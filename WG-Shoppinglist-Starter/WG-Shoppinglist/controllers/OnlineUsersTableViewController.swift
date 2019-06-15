//
//  OnlineUsersTableViewController.swift
//  WG-Shoppinglist
//
//  Created by Christian Schneeweiss on 15.06.19.
//  Copyright © 2019 Christian Schneeweiss. All rights reserved.
//

import UIKit
import Firebase

class OnlineUsersTableViewController: UITableViewController {
    
    // MARK: Constants
    let userCell = "UserCell"
    
    // MARK: Properties
    var currentUsers: [String] = []
    #warning("Hier online Referenz einfügen")

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        #warning("Diesen Code ersetzen")
        currentUsers.append("mc@hagenberg.at")
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        #warning("alten Code mit neuem zum ausloggen ersetzen")
        dismiss(animated: true, completion: nil)
    }
}

