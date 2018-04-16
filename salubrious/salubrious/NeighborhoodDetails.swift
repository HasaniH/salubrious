//
//  NeighborhoodDetails.swift
//  salubrious
//
//  Created by Hasani Hendrix on 4/16/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct NeighborhoodDetails {
    
    let Address:String!
    let Name:String!
    let Phone:String!
    let Website:String!
    
    init(Address:String, Name:String, Phone:String, Website:String) {
        self.Address = Address
        self.Name = Name
        self.Phone = Phone
        self.Website = Website
    }
}
