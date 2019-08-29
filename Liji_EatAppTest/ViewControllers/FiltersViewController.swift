//
//  FiltersViewController.swift
//  Liji_EatAppTest
//
//  Created by Liji on 8/28/19.
//  Copyright © 2019 Liji. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - IBOUTLETS
    @IBOutlet var priceButton: [UIButton]! // collection of price Buttons
    @IBOutlet weak var tblViewFilters: UITableView!
    
    //MARK: - DECLARATIONS
    var arrFilterNames = ["Cuisines", "Neighbourhood"]
    var arrFilterImages = [AppImages.Cuisine , AppImages.Neighbourhood]
    var selectedRow = 0
    
    //MARK: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewFilters.tableFooterView = UIView()
        self.title = "Filters"
        
        //retain previously selectedprice selector state
        retainPriceSelectionState()
        
    }
    
    // MARK: - TABLEVIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFilterNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.FilterCell, for: indexPath) as! FilterCell
        
        cell.lblFilter.text = self.arrFilterNames[indexPath.row]
        cell.imgViewFilter.image = UIImage(named: self.arrFilterImages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        performSegue(withIdentifier: Segues.ToFilterLists, sender: self)
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func priceButtonClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        sender.applyButtonChanges(isSelected: sender.isSelected)
        
        switch sender.tag {
        case 0:
            priceButton[1].applyButtonChanges(isSelected: false)
            priceButton[2].applyButtonChanges(isSelected: false)
            priceButton[3].applyButtonChanges(isSelected: false)
            priceButton[1].isSelected = false
            priceButton[2].isSelected = false
            priceButton[3].isSelected = false
            
            SharedClass.priceLevels = []
        case 1,2,3:
            if(SharedClass.priceLevels.contains(sender.tag) &&
                !sender.isSelected){
                SharedClass.priceLevels.remove(at: sender.tag)
            }
            else{
                if(sender.isSelected){
                    SharedClass.priceLevels.append(sender.tag)
                }
            }
            
            priceButton[0].applyButtonChanges(isSelected: false)
            priceButton[0].isSelected = false
        default:
            print("")
        }
    }
    
    @IBAction func btnApplyFiltersClicked(_ sender: Any) {
        
        // POST NOTIFICATION TO REFRESH RESTAURANRS WITH FILTERS
        NotificationCenter.default.post(name: .refreshRestaurant, object: self)
        print("posting notification")
        
        popToHomeViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToFilterLists {
            if let destination = segue.destination as? FilterListingViewController {
                destination.pageTitle = arrFilterNames[selectedRow]
                
            }
        }
    }
    
    //MARK: - CUSTOM METHODS
    func popToHomeViewController()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: RestaurantListingViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func retainPriceSelectionState()
    {
        if(!SharedClass.priceLevels.isEmpty){
            priceButton[0].applyButtonChanges(isSelected: false)
            priceButton[0].isSelected = false
            
            for i in 0..<SharedClass.priceLevels.count{
                if(SharedClass.priceLevels[i] == 1){
                    priceButton[1].applyButtonChanges(isSelected: true)
                    priceButton[1].isSelected = true
                }
                if(SharedClass.priceLevels[i] == 2){
                    priceButton[2].applyButtonChanges(isSelected: true)
                    priceButton[2].isSelected = true
                }
                if(SharedClass.priceLevels[i] == 3){
                    priceButton[3].applyButtonChanges(isSelected: true)
                    priceButton[3].isSelected = true
                }
            }
        }
    }
}
