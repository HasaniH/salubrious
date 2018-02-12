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
    let content:String!
    let addedByUser:String!
    let itemRef:DatabaseReference?
    
    init(content:String, addedByUser:String, key:String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        let value = snapshot.value as? NSDictionary
        
        if let restaurantContent = value!["content"] as? String {
            content = restaurantContent
        } else {
            content = ""
        }
        
        if let restaurantUser = value!["addedByUser"] as? String {
            addedByUser = restaurantUser
        } else {
            addedByUser = ""
        }
    }
    
    func toAnyObject() -> AnyObject {
        return ["content":content, "addedByUser":addedByUser] as NSDictionary
    }
}
