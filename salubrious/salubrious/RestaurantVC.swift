//
//  SignOutVC.swift
//  Kilo Loco Firebase Email
//
//  Created by Kyle Lee on 5/7/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import Firebase

class RestaurantVC: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username = Auth.auth().currentUser?.displayName else { return }
        
        label.text = "Hello \(username)"
        
    }
    
    
    
    @IBAction func onSignOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch {
            print(error)
        }
        
    }
}
