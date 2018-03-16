//
//  RestaurantVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/15/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RestaurantsVC: UIViewController {
    
    var dbRef:DatabaseReference!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("Neighborhoods")
        
        guard (Auth.auth().currentUser?.displayName) != nil else { return }
        
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        let userID = Auth.auth().currentUser?.displayName
        let restaurantAlert = UIAlertController(title: "New Restaurant", message: "Enter your restaurant information: ", preferredStyle: .alert)
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Neighborhood"
        }
        
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Address"
        }
        
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Name"
        }
        
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Phone"
        }
        
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Website"
        }
        
        restaurantAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            let neighborhood = restaurantAlert.textFields![0] as UITextField
            let address = restaurantAlert.textFields![1] as UITextField
            let name = restaurantAlert.textFields![2] as UITextField
            let phone = restaurantAlert.textFields![3] as UITextField
            let website = restaurantAlert.textFields![4] as UITextField
            
            if address.text != "", name.text != "", phone.text != "", website.text != "" {
                let restaurant = Restaurant(Neighborhood: neighborhood.text!, Address: address.text!, Name: name.text!, Phone: phone.text!, Website: website.text!)
                
                let restaurantRef = self.dbRef.child(neighborhood.text!)
                
                restaurantRef.updateChildValues(restaurant.toAnyObject() as! [AnyHashable : Any])
            }
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields")
                return
            }
        }))
        
        self.present(restaurantAlert, animated:true, completion: nil)
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
