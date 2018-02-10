//
//  RestaurantsTableViewController.swift
//  salubrious
//
//  Created by Hasani Hendrix on 2/10/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RestaurantsTableViewController: UITableViewController {
    
    var dbRef:DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("healthy-restaurants")

    }
    @IBAction func addRestaurant(_ sender: Any) {
        
        let restaurantAlert = UIAlertController(title: "New Restaurant", message: "Enter your restaurant: ", preferredStyle: .alert)
        restaurantAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your Restaurant"
        }
        restaurantAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let restaurantContent = restaurantAlert.textFields?.first?.text {
                let restaurant = Restaurant(content: restaurantContent, addedByUser: "HasaniHendrix")
                
                let restaurantRef = self.dbRef.child(restaurantContent.lowercased())
                
                restaurantRef.setValue(restaurant.toAnyObject())
            }
        }))
        
        self.present(restaurantAlert, animated:true, completion: nil)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)


        return cell
    }


}
