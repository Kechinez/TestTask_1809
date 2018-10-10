//
//  HotelsViewModel.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 08.10.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelViewModel {
    
    var cellViewModels: [HotelCellViewModel] = [HotelCellViewModel]()
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: ((Bool)->())?
    
    init() {
        fetchData()
    }
    
    
    private func fetchData() {
        NetworkManager.getHotels { [unowned self] (result) in
            switch result {
            case .Success(let hotels):
                self.cellViewModels = hotels.map({ return self.createCellViewModel(using: $0)})
                if let closure = self.reloadTableViewClosure {
                    closure()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func createCellViewModel(using hotel: Hotel) -> HotelCellViewModel {
        return HotelCellViewModel(hotelName: hotel.name, distance: hotel.distanceString, stars: hotel.stars, roomsAvailable: hotel.roomsAvailable)
    }
    
    func getCellModel(under index: Int) -> HotelCellViewModel {
        return cellViewModels[index]
    }
    
}


struct HotelCellViewModel {
    let hotelName: String
    let distance: String
    let stars: Int
    let roomsAvailable: Int
    
    func showHotelStars(in stackView: UIStackView) {
        for (index, star) in stackView.arrangedSubviews.enumerated() {
            if index < stars {
                star.alpha = 1.0
            } else {
                star.alpha = 0.3
            }
        }
    }
}





