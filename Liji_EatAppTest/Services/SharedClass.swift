//
//  SharedClass.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import Foundation

// SignleTon class

let SharedClass = _SharedClass()

enum FilterType {
    case Cuisine
    case Neighbourhood
    case None
}

final class _SharedClass
{
    var arrCusines = [CuisineNeighbourhoodData]()
    var arrNeighbourhood = [CuisineNeighbourhoodData]()
    var cuisineIds: [String] = []
    var neighbourhoodIds: [String] = []
    var priceLevels: [Int] = []
    var filterType = FilterType.None
    var currentPage = 1
    var totalRestaurantsCount = 0
}
