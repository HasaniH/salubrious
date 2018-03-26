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

class UserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var handle:DatabaseHandle!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableRestaurants: UITableView!
    
    var restaurantList = [Restaurant]()
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
                            website = value as! String
                        default: break
                        }
                        count += 1
                    }
                    let restaurant = Restaurant(Neighborhood: snapshot.key, Address: address, Name: name, Phone: phone, Website: website, key: keyString as! String)
                    self.restaurantList.append(restaurant)
                }
                DispatchQueue.main.async(execute: {
                    self.tableRestaurants.reloadData()
                })
            }
        })
        self.tableRestaurants.delegate = self
        self.tableRestaurants.dataSource = self
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
