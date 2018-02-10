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
