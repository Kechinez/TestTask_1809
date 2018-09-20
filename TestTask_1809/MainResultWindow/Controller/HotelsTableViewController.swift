//
//  HotelsTableViewController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 18.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelsTableViewController: UITableViewController {
    
    var isFiltered = false
    let cellId = "HotelCell"
    var hotels: [Hotel] = []
    var hotelFilter: Filter? {
        willSet {
            isFiltered = false
        }
    }
    unowned var hotelsTableView: UITableView {
        return (view as! HotelsTableView).tableView
    }
    
    
    override func loadView() {
        view = HotelsTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hotelsTableView.delegate = self
        hotelsTableView.dataSource = self
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(moveToSearchFilterController))
        
        NetworkManager.getHotels { [weak self] (result) in
            switch result {
            case .Success(let hotel):
                self?.hotels = hotel
            (self?.view as! HotelsTableView).tableView.reloadData()
            self?.hotelsTableView.reloadData()
            case .Failure(let error): print(error)
            }
        }
        self.title = "Hotels"
    }

    
    @objc private func moveToSearchFilterController() {
        let nextVC = SearchFilterController()
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let filter = hotelFilter, isFiltered == false else { return }
        hotels.sortHotels(using: filter)
        tableView.reloadData()
    }
 
    
}




// MARK: - TableViewController methods
extension HotelsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HotelCell
        let currentHotel = hotels[indexPath.row]
        
        cell.nameLabel.text = currentHotel.name
        cell.distanceLabel.text = currentHotel.distanceString
        cell.showHotelStars(currentHotel.stars)
        
       // if cell.nameLabel.li
        
        //cell.roomLeftLabel.text = currentHotel.roomsAvailableString
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CurrentHotelController()
        nextVC.currentHotel = hotels[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}



