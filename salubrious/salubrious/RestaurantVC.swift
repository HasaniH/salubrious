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
    
    var handle:DatabaseHandle!
    var tableRestaurants: UITableView!
    var restaurantList = [Restaurant]()
    
    let userID = Auth.auth().currentUser?.displayName
    let dbRef = Database.database().reference().child("Neighborhoods")
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
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
        retrieveRestaurants()
    }
    
    func retrieveRestaurants(){
        dbRef.observe(.childAdded, with: {
            (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                                
                let dictionary = snapshot.value as! NSDictionary
                
                var address:String = ""
                var name:String = ""
                var phone:String = ""
                var website: String = ""
                var user: String = ""
                
                
                for (keyString, value) in dictionary {
                    let valueDict = value as! NSDictionary
                    var count = 0
                    
                    for (_, value) in valueDict {
                        switch count {
                        case 0:
                            address = value as! String
                        case 1:
                            name = value as! String
                        case 2:
                            phone = value as! String
                        case 3:
                            user = value as! String
                        case 4:
                            website = value as! String
                        default: break
                        }
                        count += 1
                    }
                    if user == self.userID {
                        let restaurant = Restaurant(Neighborhood: snapshot.key, Address: address, Name: name, Phone: phone, Website: website, User: self.userID!, key: keyString as! String)
                        self.restaurantList.append(restaurant)
                    }
                }
                    DispatchQueue.main.async(execute: {
                    self.tableRestaurants.reloadData()
                })
            }
        })
        self.tableRestaurants.delegate = self
        self.tableRestaurants.dataSource = self
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        
        if Auth.auth().currentUser?.email?.range(of:"owner.com") == nil {
            AlertController.showAlert(self, title: "Not Accessible", message: "You are not an authenticated owner.")
            return
        } else {
        
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
                    let newRestaurant = Restaurant(Neighborhood: neighborhood.text!, Address: address.text!, Name:  name.text!, Phone: phone.text!, Website: website.text!, User: self.userID!, key: key)
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
