//
//  User.swift
//  WG-Shoppinglist
//
//  Created by Christian Schneeweiss on 15.06.19.
//  Copyright © 2019 Christian Schneeweiss. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

