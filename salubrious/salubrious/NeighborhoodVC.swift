//
//  NeighborhoodVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 4/16/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NeighborhoodVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var neighborhoodList: [NeighborhoodDetails]?
    var restaurantList: [Restaurant]!
    var hasZip: Bool?
    var zipCode: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    let dbRef = Database.database().reference().child("Neighborhoods")
    
    func retrieveRestaurants() {
        if self.hasZip! {
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
                        case 5:
                            zip = value as! String
                        default: break
                        }
                        count += 1
                    }
                    
                    
                    let restaurant = Restaurant(Neighborhood: snapshot.key, Address: address, Name: name, Phone: phone, Website: website, Zip: zip, User: user, key: keyString as! String)
                    
                        if restaurant.Zip == self.zipCode {
                            self.restaurantList.append(restaurant)
                        }
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
        self.tableView.delegate = self
        self.tableView.dataSource = self
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasZip! {
            return self.neighborhoodList!.count
        } else {
            return self.restaurantList!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! NeighborhoodTableViewCell
        let neighborhood: NeighborhoodDetails
        let restaurant: Restaurant
        
        if !hasZip! {
        
            neighborhood = (neighborhoodList?[indexPath.row])!
            cell.addressLbl.text = neighborhood.Address
            cell.nameLbl.text = neighborhood.Name
            cell.phoneLbl.text = neighborhood.Phone
            cell.websiteLbl.text = neighborhood.Website
        } else {
            restaurant = (restaurantList?[indexPath.row])!
            cell.addressLbl.text = restaurant.Address
            cell.nameLbl.text = restaurant.Name
            cell.phoneLbl.text = restaurant.Phone
            cell.websiteLbl.text = restaurant.Website
        }
        
        cell.nameLbl.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        return cell
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBack", sender: self)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        retrieveRestaurants()
        
        // Do any additional setup after loading the view.
    }
}
