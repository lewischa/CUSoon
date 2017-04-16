//
//  FavoritesTableViewCell.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/15/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var favoriteTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var contact: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set text colors to green
        address.textColor = UIColor(red: 109/255, green: 253/255, blue: 30/255, alpha: 1)
        contact.textColor = UIColor(red: 109/255, green: 253/255, blue: 30/255, alpha: 1)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //set text colors to green
        address.textColor = UIColor(red: 109/255, green: 253/255, blue: 30/255, alpha: 1)
        contact.textColor = UIColor(red: 109/255, green: 253/255, blue: 30/255, alpha: 1)
    }

}
