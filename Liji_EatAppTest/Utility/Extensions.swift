//
//  Extensions.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let refreshRestaurant = Notification.Name("refreshRestaurant")
}

extension UIViewController {
    
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension UIButton
{
    func applyButtonChanges (isSelected:Bool) {
        
        if isSelected
        {
            self.backgroundColor = AppColors.Green
            self.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            self.backgroundColor =  AppColors.OffWhite
            self.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
}

