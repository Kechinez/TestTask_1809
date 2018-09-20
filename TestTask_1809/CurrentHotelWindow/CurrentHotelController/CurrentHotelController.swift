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
    
//    private var hotelImage: UIImage? {
//        didSet(newImage) {
//            //hotelView.setImage(with: newImage!)
//        }
//    }
    
    
    private var hotelMetadata: HotelMetadata?
    unowned var hotelView: CurrentHotelView {
        return view as! CurrentHotelView
    }
    
    override func loadView() {
        view = CurrentHotelView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hotelView.updateUI(with: currentHotel!)
        self.title = currentHotel!.name
        
        NetworkManager.getHotelMetadata(with: currentHotel!.id) { [weak self] (result) in
            switch result {
            case .Success(let hotelMetadata):
                self?.hotelMetadata = hotelMetadata
                guard let imageUrl = hotelMetadata.imageURL else { return }
                
                NetworkManager.getImageOfHotel(with: imageUrl, completionHandler: { [weak self] (data) in
                    switch data {
                    case .Success(let data):
                        guard let image = UIImage(data: data) else { return }
                        self?.hotelView.setImage(with: image)
                        //self?.hotelImage = image
                    case .Failure(let error): print(error)
                    }
                })
                
            case .Failure(let error): print(error)
            }
        }
    }

    
    

}
