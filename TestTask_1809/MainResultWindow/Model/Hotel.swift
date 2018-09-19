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
    let distance: Double
    let roomsAvailable: Int
}


protocol ExtraInformation {
    var imageURL: String { get set}
    var coordinates: CLLocationCoordinate2D { get set }
    var address: String { get set }
}



extension Hotel {
    var distanceString: String {
        return String(self.distance) + String(" km from city center")
    }
    var roomsAvailableString: String {
        return String(roomsAvailable)
    }
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
        self.distance = Double(round(_distance * 10) / 10)
        self.stars = Int(_stars)
        self.roomsAvailable = _roomsAvailable.components(separatedBy: ":").count
        
        
        
    }
    
    
}


