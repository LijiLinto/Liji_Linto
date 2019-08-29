//
//  FilterListingViewController.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit

class FilterListingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var tblViewFilterListing: UITableView!
    @IBOutlet weak var lblSelectedFilter: UILabel!
    
    //MARK: - DECLARATIONS
    var pageTitle: String?
    
    //MARK: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewFilterListing.tableFooterView = UIView()
        self.title = pageTitle
        lblSelectedFilter.text = pageTitle
        
      // This ViewController manages the listing of both Cusines and Neighbourhoods
        
        if self.title == "Cuisines"
        {
            SharedClass.filterType = FilterType.Cuisine
        }
        else
        {
            SharedClass.filterType = FilterType.Neighbourhood
        }
    }
    
    // MARK: - TABLEVIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SharedClass.filterType == FilterType.Cuisine
        {
            return SharedClass.arrCusines.count
        }
        else
        {
            return SharedClass.arrNeighbourhood.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.FilterListCell, for: indexPath) as?  FilterListingCell {
            
            // Display based on FILTER_TYPE-(Cuisine/Neighborhood)
            var filterObject:CuisineNeighbourhoodData?
            if SharedClass.filterType == FilterType.Cuisine{
                filterObject = SharedClass.arrCusines [indexPath.row]
            }else{
                filterObject = SharedClass.arrNeighbourhood [indexPath.row]
            }
            
            cell.lblFilterText.text = filterObject?.attributes?.name
            cell.imgViewTick.isHidden = filterObject!.isTickHidden!
            
            if filterObject!.isTickHidden!
            {
                cell.lblFilterText.textColor = UIColor.darkGray
            }
            else
            {
                cell.lblFilterText.textColor = AppColors.Green
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var filterObject:CuisineNeighbourhoodData?
        if SharedClass.filterType == FilterType.Cuisine{
            filterObject = SharedClass.arrCusines [indexPath.row]
        }
        else{
            filterObject = SharedClass.arrNeighbourhood [indexPath.row]
        }
        
        filterObject!.isTickHidden = !filterObject!.isTickHidden!
        // reload the particular cell
        tblViewFilterListing.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        
        // This function will retain the selection states for Cuisines and Neighborhoods
        retainSelectedFilterIDs(filterObject: filterObject!)

    }
    
    //MARK: - CUSTOM METHODS
    
    func retainSelectedFilterIDs(filterObject:CuisineNeighbourhoodData?)
    {
        if(SharedClass.filterType == FilterType.Cuisine){
            if(!SharedClass.cuisineIds.isEmpty){
                //check if id already exisits and remove if unchecked else keep as it is
                var idFound: Bool = false
                for i in 0..<SharedClass.cuisineIds.count{
                    if(SharedClass.cuisineIds[i] == filterObject?.id){
                        idFound = true
                        if(filterObject!.isTickHidden!){
                            SharedClass.cuisineIds.remove(at: i)
                            
                            break
                        }
                    }
                }
                
                if(!idFound){
                    SharedClass.cuisineIds.append((filterObject?.id)!)
                }
            }
            else
            {
                SharedClass.cuisineIds.append((filterObject?.id)!)
            }
        }
        else{
            if(!SharedClass.neighbourhoodIds.isEmpty){
                //check if id already exisits and remove if unchecked else keep as it is
                var idFound: Bool = false
                for i in 0..<SharedClass.neighbourhoodIds.count{
                    if(SharedClass.neighbourhoodIds[i] == filterObject?.id){
                        idFound = true
                        if(filterObject!.isTickHidden!){
                            SharedClass.neighbourhoodIds.remove(at: i)
                            
                            break
                        }
                    }
                }
                
                if(!idFound){
                    SharedClass.neighbourhoodIds.append((filterObject?.id)!)
                }
            }
            else
            {
                SharedClass.neighbourhoodIds.append((filterObject?.id)!)
            }
        }
    }
    
}
