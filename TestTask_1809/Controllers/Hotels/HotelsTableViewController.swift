//
//  HotelsTableViewController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 18.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()


class HotelsTableViewController: UIViewController {
    
    //var hotelViewModels: [HotelViewModel] = []
    lazy var viewModel: HotelViewModel = {
       return HotelViewModel()
    }()
    
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
    
    
    
    
    
    //MARK: - ViewController lifecycle methods
    
    override func loadView() {
        view = HotelsTableView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            self?.hotelsTableView.reloadData()
        }
        
        hotelsTableView.delegate = self
        hotelsTableView.dataSource = self
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(moveToSearchFilterController))
        
        self.title = "Hotels"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let filter = hotelFilter, isFiltered == false else { return }
        hotels.sortHotels(using: filter)
        hotelsTableView.reloadData()
    }
    
    
    
    
    
    //MARK:- Additional methods
    
    @objc private func moveToSearchFilterController() {
        let nextVC = SearchFilterController()
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
}







// MARK: - TableViewController Delegate
extension HotelsTableViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CurrentHotelController()
        nextVC.currentHotel = hotels[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }

}







//MARK:- TableView Data Source
extension HotelsTableViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HotelCell
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cell.cellViewModel = cellViewModel
        return cell
    }
    
    
}



