//
//  CurrentHotelController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import MapKit
class CurrentHotelController: UIViewController, MKMapViewDelegate {

    var currentHotel: Hotel?

    private var hotelMetadata: HotelMetadata?
    unowned private var hotelView: CurrentHotelView {
        return view as! CurrentHotelView
    }
    
    override func loadView() {
        view = CurrentHotelView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hotelView.setupMapDelegate(with: self)
        
        hotelView.updateUI(with: currentHotel!)
        self.title = currentHotel!.name
        
        NetworkManager.getHotelMetadata(with: currentHotel!.id) { [weak self] (result) in
            switch result {
            case .Success(let hotelMetadata):
                self?.hotelMetadata = hotelMetadata
                self?.hotelView.setLocation(with: hotelMetadata.coordinates)

                guard let imageUrl = hotelMetadata.imageURL else { return }
                
                //self?.hotelView.startActivityIndicator()
                
                NetworkManager.getImageOfHotel(with: imageUrl, completionHandler: { [weak self] (data) in
                    switch data {
                    case .Success(let data):
                        guard let image = UIImage(data: data) else { return }
                        self?.hotelView.setImage(with: image)
                    case .Failure(let error):
                        guard let notNilSelf = self else { return }
                        ErrorManager.showErrorMessage(with: error, shownAt: notNilSelf)
                        self?.hotelView.hideHotelImageFrame()

                    }
                })
                
            case .Failure(let error):
                guard let notNilSelf = self else { return }
                ErrorManager.showErrorMessage(with: error, shownAt: notNilSelf)
                self?.hotelView.hideHotelImageFrame()
            }
        }
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            hotelView.updateConstraintsForLandcapeMode()
        } else {
            hotelView.updateConstraintsForPortraitMode()
        }
    }

    

}
