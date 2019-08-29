//
//  RestaurantListModel.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import Foundation

// MARK: - RestaurantList
class RestaurantList: Codable {
    let data: [RestaurantData]?
    let meta: Meta?
    
}

// MARK: - Datum
class RestaurantData: Codable {
    let id: String?
    let type: TypeEnum?
    let attributes: Attributes?
   
}

// MARK: - Attributes
class Attributes: Codable {
    let name: String?
    let priceLevel: Int?
    let cuisine: String?
    let imageURL: String?
    let latitude, longitude: Double?
    let addressLine1: String?
    let ratingsAverage: String?
    let ratingsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case priceLevel = "price_level"
        case cuisine
        case imageURL = "image_url"
        case latitude, longitude
        case addressLine1 = "address_line_1"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
    
}

enum TypeEnum: String, Codable {
    case restaurant = "restaurant"
}

// MARK: - Meta
class Meta: Codable {
    let limit, totalPages, totalCount, currentPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case limit
        case totalPages = "total_pages"
        case totalCount = "total_count"
        case currentPage = "current_page"
    }
    
}


