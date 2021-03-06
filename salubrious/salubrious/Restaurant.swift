//
//  Restaurant.swift
//  salubrious
//
//  Created by Hasani Hendrix on 2/10/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Restaurant {
    
    let key:String!
    let Neighborhood:String!
    let Address:String!
    let Name:String!
    let Phone:String!
    let Website:String!
    let Zip: String!
    let User:String!
    let itemRef:DatabaseReference?
    
    init(Neighborhood:String, Address:String, Name:String, Phone:String, Website:String, Zip:String, User: String, key:String = "") {
        self.key = key
        self.Neighborhood = Neighborhood
        self.Address = Address
        self.Name = Name
        self.Phone = Phone
        self.Website = Website
        self.Zip = Zip
        self.User = User
        self.itemRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        if let restaurantNeighborhood = value!["value"] as? String {
            Neighborhood = restaurantNeighborhood
        } else {
            Neighborhood = ""
        }
        
        if let restaurantAddress = value!["Address"] as? String {
            Address = restaurantAddress
        } else {
            Address = ""
        }
        
        if let restaurantName = value!["Name"] as? String {
            Name = restaurantName
        } else {
            Name = ""
        }
        
        if let restaurantPhone = value!["Phone"] as? String {
            Phone = restaurantPhone
        } else {
            Phone = ""
        }
        
        if let restaurantWebsite = value!["Website"] as? String {
            Website = restaurantWebsite
        } else {
            Website = ""
        }
        
        if let restaurantZip = value!["Zip"] as? String {
            Zip = restaurantZip
        } else {
            Zip = ""
        }
        if let restaurantUser = value!["User"] as? String {
            User = restaurantUser
        } else {
            User = ""
        }
    }
    
    func toAnyObject() -> AnyObject {
        return ["Address":Address, "Name":Name, "Phone":Phone, "Website": Website, "Zip-Code": Zip, "Added By": User, "id": key] as NSDictionary
    }
}
