//
//  SignOutVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/15/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import Firebase

class SignOutVC: UIViewController {
    
    
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
