//
//  SignOutVC.swift
//  Kilo Loco Firebase Email
//
//  Created by Kyle Lee on 5/7/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RestaurantVC: UIViewController {
    
    var dbRef:DatabaseReference!
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("healthy-restaurants")
        
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
    
    @IBAction func addRestaurant(_ sender: Any) {
        
        let restaurantAlert = UIAlertController(title: "New Restaurant", message: "Enter your restaurant: ", preferredStyle: .alert)
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your Restaurant"
        }
        restaurantAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let restaurantContent = restaurantAlert.textFields?.first?.text {
                let userID = Auth.auth().currentUser!.uid
                let restaurant = Restaurant(content: restaurantContent, addedByUser: userID)
                
                let restaurantRef = self.dbRef.child(restaurantContent.lowercased())
                
                restaurantRef.setValue(restaurant.toAnyObject())
            }
        }))
        
        self.present(restaurantAlert, animated:true, completion: nil)
    }
}
