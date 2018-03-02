//
//  salubrious
//
//  Created by Hasani Hendrix on 2/26/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    var isLogin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        // Flip the boolean
        isLogin = !isLogin
        
        if isLogin {
            loginLabel.text = "Login Here!"
            loginButton.setTitle("Login", for: .normal)
        } else {
            loginLabel.text = "Register Here!"
            loginButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // TODO: Do some form of email and password validation
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            if isLogin {
                // Login user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if let u = user {
                        // User is found
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                    } else {
                        // Check error and show message
                        
                    }
                }
            } else {
                //Register user with Firebase
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    
                    if let u = user {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                    } else {
                        // Check error and show message
                        
                    }
                }
            }
        }
        
    }
    
    
}
