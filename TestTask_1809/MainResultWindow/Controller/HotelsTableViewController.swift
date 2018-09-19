//
//  HotelsTableViewController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 18.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelsTableViewController: UITableViewController {

    let cellId = "HotelCell"
    var hotels: [Hotel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print(UIScreen.main.bounds.width)
        NetworkManager.getHotels { [weak self] (result) in
            switch result {
            case .Success(let hotel):
                self?.hotels = hotel
                self?.tableView.reloadData()
            case .Failure(let error): print(error)
            }
        }
        
        tableView.register(HotelCell.self, forCellReuseIdentifier: cellId)
        self.title = "Hotels"
        setUpTableViewAppearance()
    }

    
    private func setUpTableViewAppearance() {
        let background = UIView()
        background.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        tableView.backgroundView = background
        tableView.rowHeight = 110
        tableView.separatorColor = #colorLiteral(red: 0.9877062183, green: 0.9068514552, blue: 0.4717055176, alpha: 1)
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
}



