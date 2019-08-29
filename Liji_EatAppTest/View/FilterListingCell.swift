//
//  FilterListingCell.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit

class FilterListingCell: UITableViewCell {

    @IBOutlet weak var lblFilterText: UILabel!
    
    @IBOutlet weak var imgViewTick: UIImageView!
    
    //var isFilterSelected
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
