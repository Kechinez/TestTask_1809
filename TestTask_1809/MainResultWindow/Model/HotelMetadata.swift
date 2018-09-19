//
//  HotelMetadata.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import MapKit

struct HotelMetadata {
    var imageURL: String?
    var coordinates: CLLocationCoordinate2D
}





extension HotelMetadata: HotelMetadataDecoding {
    init?(json: JSON) {
        guard let lat = json["lat"] as? Double,
            let lon = json["lon"] as? Double else { return nil }
        
        let _imageUrl = json["image"] as? String
        
        self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        if _imageUrl == nil || _imageUrl == "" || _imageUrl == "null" {
            self.imageURL = nil
        } else {
            self.imageURL = imageURL!
        }
    }
}
