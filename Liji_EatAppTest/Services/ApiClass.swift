//
//  ApiClass.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import Foundation
import Alamofire


class Api {
    
    //MARK: -  FETCH RESTAURANTS
    func getRestaurantData(page: Int = 1, searchText: String = "", cuisineIds: [String] = [], neighbourhoodIds: [String] = [], regionId: String = REGION_ID, priceLevels: [Int] = [], limit: Int = 5, completion: @escaping RestaurantResponseCompletion) {
        
        
        var urlParameters = RESTAURANT_URL +
            "page=\(page)&" +
            "limit=\(limit)&" +
        "region_id=\(regionId)"
        
        var cusineParameter = ""
        
        if(!cuisineIds.isEmpty && cuisineIds.count > 0){
            
            for i in 0..<cuisineIds.count
            {
                
                cusineParameter += "&cuisine_id[]=" + cuisineIds[i]
            }
            
        }
        
        var neighbourhoodParameter = ""
        if(!neighbourhoodIds.isEmpty && neighbourhoodIds.count > 0){
            
            for i in 0..<neighbourhoodIds.count
            {
                neighbourhoodParameter += "&neighborhood_id[]=" + neighbourhoodIds[i]
            }
            
        }
        
        var priceLevelParameter = ""
        if(!priceLevels.isEmpty && priceLevels.count > 0){
            
            for i in 0..<priceLevels.count
            {
                priceLevelParameter += "&price_level[]=" + "\(priceLevels[i])"
            }
            
        }
        
        urlParameters += cusineParameter +
            neighbourhoodParameter +
        priceLevelParameter
        
        //set search text
        urlParameters += "&q=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        
        //print(urlParameters)
        
        guard let url = URL(string: urlParameters) else { return }
        
        
        
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil) }
            let jsonDecoder = JSONDecoder()
            do {
                let restaurants = try jsonDecoder.decode(RestaurantList.self, from: data)
                if let totalRestaurantCount = restaurants.meta?.totalCount{
                    SharedClass.totalRestaurantsCount = totalRestaurantCount
                    print(SharedClass.totalRestaurantsCount)
                }
                completion(restaurants)
                
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK: -  FETCH CUISINE
    func getCuisines(completion: @escaping CuisineResponseCompletion) {
        
        guard let url = URL(string: "\(CUISINE_URL)") else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil)}
            let jsonDecoder = JSONDecoder()
            do {
                let cuisines = try jsonDecoder.decode(CuisineNeighbourhoodList.self, from: data)
                completion(cuisines)
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK:- FETCH NEIGHBORHOODS
    func getNeighbourhoods(completion: @escaping NeighbourhoodResponseCompletion) {
        
        guard let url = URL(string: "\(NEIGHBOURHOOD_URL)") else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.result.error {
                debugPrint(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = response.data else { return completion(nil)}
            let jsonDecoder = JSONDecoder()
            do {
                let neighbourhoods = try jsonDecoder.decode(CuisineNeighbourhoodList.self, from: data)
                completion(neighbourhoods)
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
}
