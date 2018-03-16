//
//  SignInVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/15/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func onSignInTapped(_ sender: Any) {
        
        guard let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard let user = user else { return }
            print(user.email ?? "MISSING EMAIL")
            print(user.displayName ?? "MISSING DISPLAY NAME")
            print(user.uid)
            
            if email.range(of:"owner.com") != nil {
                self.performSegue(withIdentifier: "ownerSignInSegue", sender: nil)
            }
        })
    }
}
