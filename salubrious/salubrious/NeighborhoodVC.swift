//
//  NeighborhoodVC.swift
//  salubrious
//
//  Created by Hasani Hendrix on 4/16/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit

class NeighborhoodVC: UIViewController {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    
    var neighborhood: [NeighborhoodDetails]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLbl.text = neighborhood?[0].Address
        nameLbl.text = neighborhood?[0].Name
        phoneLbl.text = neighborhood?[0].Phone
        websiteLbl.text = neighborhood?[0].Website
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
