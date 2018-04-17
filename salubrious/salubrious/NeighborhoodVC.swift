//
//  NeighborhoodVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 4/16/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit

class NeighborhoodVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var neighborhoodList: [NeighborhoodDetails]?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.neighborhoodList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! NeighborhoodTableViewCell
        
        let neighborhood: NeighborhoodDetails
        
        neighborhood = (neighborhoodList?[indexPath.row])!
        cell.addressLbl.text = "Address: " + neighborhood.Address
        cell.nameLbl.text = "Name: " + neighborhood.Name
        cell.phoneLbl.text = "Phone: " + neighborhood.Phone
        cell.websiteLbl.text = "Website: " + neighborhood.Website
        
        return cell
    }
    @IBAction func onBackPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBack", sender: self)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
