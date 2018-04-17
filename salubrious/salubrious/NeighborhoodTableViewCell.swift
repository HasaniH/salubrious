//
//  NeighborhoodTableViewCell.swift
//  salubrious
//
//  Created by Hasani Hendrix on 4/16/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit

class NeighborhoodTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
