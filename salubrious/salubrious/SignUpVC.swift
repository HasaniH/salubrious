//
//  SignUpVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/15/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBAction func onSignUpTapped(_ sender: Any) {
        
        guard let username = usernameTF.text,
            username != "",
            let email = emailTF.text,
            email != "",
            let password = passwordTF.text,
            password != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields")
                return
            }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard let user = user else { return }
            print(user.email ?? "MISSING EMAIL")
            print(user.uid)
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: { (error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
                if email.range(of:"owner.com") != nil {
                    self.performSegue(withIdentifier: "ownerSignUpSegue", sender: nil)
                }
                
                
            })
        })
    }
}
