//
//  RestaurantCell.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var imgViewRestaurant: UIImageView!
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    
    @IBOutlet weak var btnBookNow: UIButton!
    
    @IBOutlet weak var btnCuisine: UIButton!
    
    @IBOutlet weak var btnPrice: UIButton!
    
    var restaurantData: RestaurantData!
    {
        didSet{
            updateUI()
        }
    }
    
    /// This function will update the CELL UI based on the JSON Data returned "RestaurantData"
    func updateUI()
    {
        self.lblRestaurantName.text = restaurantData.attributes?.name
        self.lblRestaurantAddress.text = restaurantData.attributes?.addressLine1
        self.btnCuisine.setTitle(restaurantData.attributes?.cuisine, for: .normal)
        
        self.btnPrice.setTitle(SharedClass.getDollarPrice(priceValue: (restaurantData.attributes?.priceLevel!)!), for: .normal)
        
        // download and cache images using Kingfisher
        if let url = URL(string: restaurantData.attributes?.imageURL ?? "") {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            self.imgViewRestaurant.kf.indicatorType = .activity
            self.imgViewRestaurant.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }
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
