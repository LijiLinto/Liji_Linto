//
//  NeighbourhoodListModel.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CuisineNeighbourhoodList
class CuisineNeighbourhoodList: Codable {
    
    let data: [CuisineNeighbourhoodData]?
    
}

// MARK: - Datum
class CuisineNeighbourhoodData: Codable {
    let id: String?
    var isTickHidden:Bool?
    let attributes: CuisineNeighbourhoodAttributes?
}

// MARK: - Attributes
class CuisineNeighbourhoodAttributes: Codable {
    let name: String?
}





