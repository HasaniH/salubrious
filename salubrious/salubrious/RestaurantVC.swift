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
    
    @IBOutlet weak var zipCodeField: UITextField!
    var hasZip: Bool = false
    var zipCode: String!
    var handle:DatabaseHandle!
    var tableRestaurants: UITableView!
    var restaurantList = [Restaurant]()
    var neighborhoods = [String: [NeighborhoodDetails]]()
    var tableIndex = 0
    
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
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurantList[indexPath.row]
        
        let alertController = UIAlertController(title: restaurant.Name, message: "Give new values to update restaurant", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let id = restaurant.key
            let neighborhood = restaurant.Neighborhood
            
            let name = alertController.textFields![0] as UITextField
            let address = alertController.textFields![1] as UITextField
            let phone = alertController.textFields![2] as UITextField
            let website = alertController.textFields![3] as UITextField
            let zip = alertController.textFields![4] as UITextField
            
            self.updateRestaurant(id: id!, name: name.text!, address: address.text!, phone: phone.text!, website: website.text!, zip: zip.text!, neighborhood: neighborhood!)
        }
            
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            let id = restaurant.key
            let neighborhood = restaurant.Neighborhood
            
            self.deleteRestaurant(id: id!, neighborhood: neighborhood!)
        }
        
        let segueAction = UIAlertAction(title: "See Restaurants", style: .default) { (_) in
            self.performSegue(withIdentifier: "showDetails", sender: self)
        }
        
        alertController.addTextField{(textField) in
            textField.text = restaurant.Address
        }
        
        alertController.addTextField{(textField) in
            textField.text = restaurant.Name
        }
        
        alertController.addTextField{(textField) in
            textField.text = restaurant.Phone
        }
        
        alertController.addTextField{(textField) in
            textField.text = restaurant.Website
        }
        
        alertController.addTextField{(textField) in
            textField.text = restaurant.Zip
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(segueAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func updateRestaurant(id: String, name: String, address: String, phone: String, website: String, zip: String, neighborhood: String) {
        let restaurant = Restaurant(Neighborhood: neighborhood, Address: address, Name: name, Phone: phone, Website: website, Zip: zip, User: self.userID!, key: id)
        
        dbRef.child(neighborhood).child(id).setValue(restaurant.toAnyObject() as! [AnyHashable : Any])
    }
    
    func deleteRestaurant(id: String, neighborhood: String) {
        dbRef.child(neighborhood).child(id).setValue(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NeighborhoodVC {
            if (!self.hasZip) {
                destination.neighborhoodList = neighborhoods[restaurantList[(tableRestaurants.indexPathForSelectedRow?.row)!].Neighborhood]
                destination.hasZip = self.hasZip
            } else {
                destination.restaurantList = restaurantList
                destination.hasZip = self.hasZip
                destination.zipCode = self.zipCode
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveRestaurants()
        
    }
    
    func retrieveRestaurants() {
        dbRef.observe(.childAdded, with: {
            (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let dictionary = snapshot.value as! NSDictionary
                
                var address:String = ""
                var name:String = ""
                var phone:String = ""
                var website: String = ""
                var zip: String = ""
                var user: String = ""
                var id: String = ""
                
                for (keyString, value) in dictionary {
                    let valueDict = value as! NSDictionary
                    var count = 0
                    
                    for (key, value) in valueDict {
                        switch key as! String {
                        case "Address":
                            address = value as! String
                        case "Name":
                            name = value as! String
                        case "Phone":
                            phone = value as! String
                        case "Added By":
                            user = value as! String
                        case "Website":
                            website = value as! String
                        case "Zip-Code":
                            zip = value as! String
                        case "id":
                            id = value as! String
                        default: break
                    }
                        count += 1
                    }
                    
                    let details = NeighborhoodDetails(Address: address, Name: name, Phone: phone, Website: website)
                    
                    if Auth.auth().currentUser?.email?.range(of:"owner.com") == nil {
                        let restaurant = Restaurant(Neighborhood: snapshot.key, Address: address, Name: name, Phone: phone, Website: website, Zip: zip, User: user, key: keyString as! String)
                        
                        if self.hasZip {
                            if restaurant.Zip == self.zipCode {
                                print(restaurant.Zip)
                                self.restaurantList.append(restaurant)
                            }
                        } else {
                            let keyExists = self.neighborhoods.keys.contains(restaurant.Neighborhood)
                            if !keyExists {
                                self.restaurantList.append(restaurant)
                                self.neighborhoods[restaurant.Neighborhood] = [details]
                            } else {
                                self.neighborhoods[restaurant.Neighborhood]?.append(details)
                            }
                        }
                    } else {
                        if user == self.userID {
                            let restaurant = Restaurant(Neighborhood: snapshot.key, Address: address, Name: name, Phone: phone, Website: website, Zip: zip, User: user, key: keyString as! String)
                            
                            let keyExists = self.neighborhoods.keys.contains(restaurant.Neighborhood)
                            if !keyExists {
                                self.restaurantList.append(restaurant)
                                self.neighborhoods[restaurant.Neighborhood] = [details]
                            } else {
                                self.neighborhoods[restaurant.Neighborhood]?.append(details)
                            }
                        }
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
                textField.placeholder = "Zip Code"
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
                let zip = restaurantAlert.textFields![2] as UITextField
                let name = restaurantAlert.textFields![3] as UITextField
                let phone = restaurantAlert.textFields![4] as UITextField
                let website = restaurantAlert.textFields![5] as UITextField
                
                
                if address.text != "", name.text != "", phone.text != "", website.text != "" {
                    let key = self.dbRef.childByAutoId().key
                    let newRestaurant = Restaurant(Neighborhood: neighborhood.text!, Address: address.text!, Name:  name.text!, Phone: phone.text!, Website: website.text!, Zip: zip.text!, User: self.userID!, key: key)
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
    

    @IBAction func zipTapped(_ sender: Any) {
        if zipCodeField.text?.characters.count != 5 {
            AlertController.showAlert(self, title: "Incomplete Zip Code", message: "Please fill out zip code in its entirety")
        } else {
            self.hasZip = true
            self.zipCode = zipCodeField.text
            restaurantList.removeAll()
            retrieveRestaurants()
            performSegue(withIdentifier: "showDetails", sender: self)
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

extension RestaurantVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
