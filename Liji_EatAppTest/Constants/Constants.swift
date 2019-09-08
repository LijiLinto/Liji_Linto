//
//  Constants.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import Foundation
import UIKit

let URL_BASE = "https://api.sandbox.eatapp.co/consumer/v2/"
let REGION_ID = "3906535a-d96c-47cf-99b0-009fc9e038e0"

let RESTAURANT_URL = URL_BASE + "restaurants?"
let CUISINE_URL = URL_BASE + "cuisines?region_id=" + REGION_ID
let NEIGHBOURHOOD_URL = URL_BASE + "neighborhoods?region_id=" + REGION_ID

let ALERT_MSG = "No Restaurants avaialble for this filter."

typealias RestaurantResponseCompletion = (RestaurantList?) -> Void
typealias CuisineResponseCompletion = (CuisineNeighbourhoodList?) -> Void
typealias NeighbourhoodResponseCompletion = (CuisineNeighbourhoodList?) -> Void


struct Storyboard {
    static let Main = "Main"
}

struct AppImages {
    static let Cuisine = "cusine"
    static let Neighbourhood = "neighbourhood"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let OffWhite = #colorLiteral(red: 0.976374805, green: 0.9765381217, blue: 0.9849618077, alpha: 1)
    static let Green = #colorLiteral(red: 0.5158153772, green: 0.7822643518, blue: 0.4670167565, alpha: 1)
    
}

struct Identifiers {
    static let FilterCell = "FilterCell"
    static let FilterListCell = "FilterListingCell"
    static let RestaurantCell = "RestaurantCell"
    
    
}

struct Segues {
    static let ToFilterLists = "toFilterListingCell"
    static let ToFilterView = "toFilterView"
    static let ToFilterMain = "toFilterMain"
    }


