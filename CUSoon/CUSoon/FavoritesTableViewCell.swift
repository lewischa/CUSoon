//
//  FavoritesTableViewCell.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
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
        self.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
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
    
    func useService(service: ServiceModel) {
        if let title = service.title {
            favoriteTitle.text = title
        }
        
        switch (service.service_type) {
        case 0:     // Alarm Only
            serviceImage.image = #imageLiteral(resourceName: "alarm54")
        case 1:     // Message Only
            serviceImage.image = #imageLiteral(resourceName: "speehcbubble")
        case 2:     // Alarm + Message
            serviceImage.image = #imageLiteral(resourceName: "alarm_text_icon")
        default:
            serviceImage.image = #imageLiteral(resourceName: "alarm_text_icon")
        }
        
//        service.reverseGeocode(completion: {
//            (addressToUse) -> Void in
//            self.address.text = addressToUse
//        })
        if let addr = service.address {
            self.address.text = addr
        }
        
        if let name = service.name {
            contact.text = name
        }
    }

}
