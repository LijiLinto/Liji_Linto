//
//  RestaurantListingViewController.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit
import Kingfisher
import JGProgressHUD

class RestaurantListingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var tblViewRestaurantList: UITableView!
    @IBOutlet weak var btnClearFilter: UIButton!
    
    //MARK: - DECLARATIONS
    let hud = JGProgressHUD(style: .dark)
    var observer: NSObjectProtocol?
    var api = Api()
    var arrOfRestaurants = [RestaurantData]()
    var searchBar:UISearchBar!
    
    //MARK: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        
        hud.show(in: self.view)
        // LOADING RESTAURANT API
        api.getRestaurantData(cuisineIds: SharedClass.cuisineIds, neighbourhoodIds: SharedClass.neighbourhoodIds, priceLevels: SharedClass.priceLevels){ (restaurant) in
            
            SharedClass.currentPage+=1
            if let restaurants = restaurant
            {
                self.arrOfRestaurants = restaurants.data ?? []
                self.tblViewRestaurantList.reloadData()
                self.scrollToTopOfList()
                self.hud.dismiss(afterDelay: 0)
                
            }
            
        }
        
        // LOADING CUISINE API
        api.getCuisines { (cusines) in
            if let cuisines = cusines?.data
            {
                SharedClass.arrCusines = cuisines
                
                // Adding custom isTick property here by setting it to true innitially
                for i in 0..<SharedClass.arrCusines.count
                {
                    SharedClass.arrCusines[i].isTickHidden = true
                }
            }
        }
        
        // LOADING NEIGHBOURHOOD API
        api.getNeighbourhoods { (neighbourhoods) in
            if let neighbourhoods = neighbourhoods?.data
            {
                SharedClass.arrNeighbourhood = neighbourhoods
                for i in 0..<SharedClass.arrNeighbourhood.count
                {
                    SharedClass.arrNeighbourhood[i].isTickHidden = true
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!SharedClass.priceLevels.isEmpty ||
            !SharedClass.cuisineIds.isEmpty ||
            !SharedClass.neighbourhoodIds.isEmpty){
            self.btnClearFilter.isHidden = false
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // add obsever for refreshing restaurant list based on filters
        
        print("Adding observer..")
        
        if let observer = observer
        {
            NotificationCenter.default.removeObserver(observer)
        }
        observer = NotificationCenter.default.addObserver(forName: .refreshRestaurant, object: nil, queue: OperationQueue.main) { (notification) in
            self.hud.show(in: self.view)
            SharedClass.currentPage = 1
            
            self.api.getRestaurantData(page: SharedClass.currentPage, cuisineIds: SharedClass.cuisineIds, neighbourhoodIds: SharedClass.neighbourhoodIds, priceLevels: SharedClass.priceLevels){ (restaurant) in
                
                SharedClass.currentPage += 1
                
                print("Refreshing Restaurants....")
                if let restaurants = restaurant
                {
                    self.hud.dismiss(afterDelay: 0)
                    self.arrOfRestaurants = restaurants.data ?? []
                    self.tblViewRestaurantList.reloadData()
                    self.scrollToTopOfList()
                    
                }
                
            }
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("removed observer..")
        if let observer = observer
         {
         //NotificationCenter.default.removeObserver(observer)
         }
    }
    
    // MARK: - TABLEVIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RestaurantCell, for: indexPath) as? RestaurantCell
        {
            cell.lblRestaurantName.text = arrOfRestaurants[indexPath.row].attributes?.name
            cell.lblRestaurantAddress.text = arrOfRestaurants[indexPath.row].attributes?.addressLine1
            cell.btnCuisine.setTitle(arrOfRestaurants[indexPath.row].attributes?.cuisine, for: .normal)
            
            cell.btnPrice.setTitle(getDollarPrice(priceValue: (arrOfRestaurants[indexPath.row].attributes?.priceLevel!)!), for: .normal)
            
            // download and cache images using Kingfisher
            if let url = URL(string: arrOfRestaurants[indexPath.row].attributes?.imageURL ?? "") {
                let placeholder = UIImage(named: "placeholder")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                cell.imgViewRestaurant.kf.indicatorType = .activity
                cell.imgViewRestaurant.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //PAGINATION
        if indexPath.row == arrOfRestaurants.count - 1
        {
            // we are at the last cell, so now load more items
            if arrOfRestaurants.count < SharedClass.totalRestaurantsCount
            {
                // call the API to load more
                print("Loading More Records")
                hud.show(in: self.view)
                api.getRestaurantData(page:SharedClass.currentPage, cuisineIds: SharedClass.cuisineIds, neighbourhoodIds: SharedClass.neighbourhoodIds, priceLevels: SharedClass.priceLevels){ (restaurant) in
                    
                    if let restaurants = restaurant
                    {
                        if let restaurants = restaurants.data
                        {
                            for restaurant in restaurants
                            {
                                self.arrOfRestaurants.append(restaurant)
                                self.appendNewRestaurantToTable()
                            }
                            
                            SharedClass.currentPage += 1
                        }
                        
                        self.hud.dismiss(afterDelay: 0)
                        
                        
                    }
                    
                }
            }
            else
            {
                print("No More records")
            }
        }
    }
    
    //MARK: - CUSTOM METHODS
    
    func appendNewRestaurantToTable (){
        
        self.tblViewRestaurantList.beginUpdates()
        let selectedIndexPath = IndexPath(row: self.arrOfRestaurants.count - 1, section: 0)
        self.tblViewRestaurantList.insertRows(at: [selectedIndexPath], with: .automatic)
        self.tblViewRestaurantList.endUpdates()
    }
    
    func initialSetup()
    {
        
        hud.textLabel.text = "Loading"
        
        // Method for creating SearchBar
        makeSearchBar()
        self.title = "Restaurants"
        self.navigationController?.navigationBar.barTintColor = AppColors.Green
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        tblViewRestaurantList.tableFooterView = UIView()
        btnClearFilter.isHidden = true
    }
    
    
    func makeSearchBar() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.placeholder = "Search for restaurants"
        navigationItem.titleView = searchBar
    }
    
    func scrollToTopOfList()
    {
        // check if there are records only then scroll
        if self.tblViewRestaurantList.numberOfRows(inSection: 0) >= 1
        {
            self.tblViewRestaurantList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        else // Show Alert if there no records
        {
            let alert = UIAlertController(title: "Alert", message: ALERT_MSG, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.clearFilters()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    func getDollarPrice(priceValue:Int) -> String
    {
        switch priceValue {
        case 1:
            return "$"
        case 2:
            return "$$"
        case 3:
            return "$$$"
        default:
            return "$"
        }
    }
    
    func clearFilters()
    {
        SharedClass.cuisineIds = []
        SharedClass.neighbourhoodIds = []
        SharedClass.priceLevels = []
        SharedClass.filterType = FilterType.None
        SharedClass.currentPage = 1
        
        //reset check boxes in the Filters
        for i in 0..<SharedClass.arrCusines.count
        {
            SharedClass.arrCusines[i].isTickHidden = true
        }
        
        for i in 0..<SharedClass.arrNeighbourhood.count
        {
            SharedClass.arrNeighbourhood[i].isTickHidden = true
        }
        
        btnClearFilter.isHidden = true
        
        // call the API with empty filters
        hud.show(in: self.view)
        api.getRestaurantData(){ (restaurant) in
            SharedClass.currentPage += 1
            
            if let restaurant = restaurant
            {
                self.hud.dismiss(afterDelay: 0)
                self.arrOfRestaurants = restaurant.data ?? []
                self.tblViewRestaurantList.reloadData()
                self.scrollToTopOfList()
            }
            
        }
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnApplyFiltersClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Storyboard.Main, bundle:nil)
        let filterVC = storyBoard.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        self.navigationController?.pushViewController(filterVC , animated: true)
    }
    
    @IBAction func btnClearFilterClicked(_ sender: Any) {
        clearFilters()
    }
    
}

//MARK: - SEARCHBAR DELEGATE METHODS

extension RestaurantListingViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" // dismiss keyboard
        {
            searchBar.resignFirstResponder()
        }
        // call API with SEARCH TEXT
        hud.show(in: self.view)
        api.getRestaurantData(searchText: searchText, cuisineIds: SharedClass.cuisineIds, neighbourhoodIds: SharedClass.neighbourhoodIds, priceLevels: SharedClass.priceLevels){ (restaurant) in
            
            if let restaurant = restaurant
            {
                self.hud.dismiss(afterDelay: 0)
                self.arrOfRestaurants = restaurant.data ?? []
                self.tblViewRestaurantList.reloadData()
                self.scrollToTopOfList()
                
            }
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
