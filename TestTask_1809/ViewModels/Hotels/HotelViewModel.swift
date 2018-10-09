//
//  HotelsViewModel.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 08.10.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

struct HotelViewModel {
    
    var cellViewModels: [HotelCellViewModel] = [HotelCellViewModel]()
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: ((Bool)->())?
    
    init() {
        fetchData()
    }
    
    
    mutating func fetchData() {
        NetworkManager.getHotels { (result) in
            switch result {
            case .Success(let hotels):
                self.cellViewModels = hotels.map({ return self.createCellViewModel(using: $0)})
                
            case .Failure(let error):
                print(error)
                
            }
        }
    }
    
    
    private func createCellViewModel(using hotel: Hotel) -> HotelCellViewModel {
        
    }
    
    
    
}


struct HotelCellViewModel {
    let hotelName: String
    let distance: String
    let stars: Int
    let roomsAvailable: Int
    let address: String
}
