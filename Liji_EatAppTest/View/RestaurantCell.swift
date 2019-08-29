//
//  RestaurantCell.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var imgViewRestaurant: UIImageView!
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    
    @IBOutlet weak var btnBookNow: UIButton!
    
    @IBOutlet weak var btnCuisine: UIButton!
    
    @IBOutlet weak var btnPrice: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnBookNow.layer.cornerRadius = 5
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
