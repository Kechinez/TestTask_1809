//
//  CurrentHotelController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class CurrentHotelController: UIViewController {

    ////  Здесь мб надо сделать weak  (!!!!!)
    var currentHotel: Hotel?
    var hotelImage: UIImage?
    unowned var hotelView: CurrentHotelView {
        return view as! CurrentHotelView
    }
    
    override func loadView() {
        view = CurrentHotelView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.getImageOfHotel(with: currentHotel!.id) { [weak self] (result) in
            switch result {
            case .Success(let data):
                guard let image = UIImage(data: data) else { return }
                self?.hotelImage = image
            
            case .Failure(let error): print(error)
            }
            
        }
        NetworkManager.getHotelMetadata(with: currentHotel!.id) { (result) in
            switch result {
            case .Success(let hotelMetadata):
                
                
            case .Failure(let error): print(error)
            }
        }
        
    }

    
    

}
