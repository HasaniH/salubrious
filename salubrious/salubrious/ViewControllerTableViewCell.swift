//
//  ViewControllerTableViewCell.swift
//  salubrious
//
//  Created by Hasani Hendrix on 3/19/18.
//  Copyright © 2018 Hasani Hendrix. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNeighborhood: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
