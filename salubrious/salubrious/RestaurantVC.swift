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

class RestaurantVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbRef:DatabaseReference!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableRestaurants: UITableView!
    
    var restaurantList = [Restaurant]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let restaurant: Restaurant
        
        restaurant = restaurantList[indexPath.row]
        cell.labelNeighborhood.text = restaurant.Neighborhood
        cell.labelName.text = restaurant.Name
        cell.labelPhone.text = restaurant.Phone
        cell.labelAddress.text = restaurant.Address
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("Neighborhoods")
        
        guard (Auth.auth().currentUser?.displayName) != nil else { return }
        
        dbRef.observe(DataEventType.value, with: {(snapshot) in
            if (snapshot.childrenCount > 0) {
                self.restaurantList.removeAll()
                
                for restaurants in snapshot.children.allObjects as! [DataSnapshot] {
                    let restaurantObject = restaurants.value as? [String: AnyObject]
                    let restaurantNeighborhood = restaurantObject?["Neighborhood"]
                    let restaurantName = restaurantObject?["Name"]
                    let restaurantPhone = restaurantObject?["Phone"]
                    let restaurantAddress = restaurantObject?["Address"]
                    let restaurantWebsite = restaurantObject?["Website"]
                    let restaurantId = restaurantObject?["id"]
                    
                    let restaurant = Restaurant(Neighborhood: restaurantNeighborhood as! String, Address: restaurantAddress as! String, Name: restaurantName as! String, Phone: restaurantPhone as! String, Website: restaurantWebsite as! String, key: restaurantId as! String)
                    
                    self.restaurantList.append(restaurant)
                }
                
                self.tableRestaurants.reloadData()
            }
        })
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
                let key = self.dbRef.childByAutoId().key
                let newRestaurant = Restaurant(Neighborhood: neighborhood.text!, Address: address.text!, Name: name.text!, Phone: phone.text!, Website: website.text!, key: key)
                
                let restaurantRef = self.dbRef.child(neighborhood.text!).child(key)
                
                restaurantRef.updateChildValues(newRestaurant.toAnyObject() as! [AnyHashable : Any])
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
