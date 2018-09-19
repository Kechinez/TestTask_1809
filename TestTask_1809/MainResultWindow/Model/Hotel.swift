//
//  Hotel.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 18.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import CoreLocation

struct Hotel: ExtraInformation {
    var imageURL = ""
    var coordinates =  CLLocationCoordinate2D()
    var address = ""
    
    let id: Int
    let name: String
    let stars: Int
    let distance: Float
    let roomsAvailable: Int
}


protocol ExtraInformation {
    var imageURL: String { get set}
    var coordinates: CLLocationCoordinate2D { get set }
    var address: String { get set }
}




extension Hotel: HotelDecoding {
    
    init?(json: JSON) {
        
        guard let _id = json["id"] as? Int,
            let _name = json["name"] as? String,
            let _stars = json["stars"] as? Double,
            let _distance = json["distance"] as? Double,
            let _roomsAvailable = json["suites_availability"] as? String else { return nil }
        
        self.id = _id
        self.name = _name
        self.distance = Float(_distance)
        self.stars = Int(_stars)
        self.roomsAvailable = _roomsAvailable.components(separatedBy: ":").count
        
        
        
    }
    
    
}


