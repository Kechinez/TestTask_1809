//
//  SortFilter.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


struct Filter {

    enum FilteringType {
        case ByAvailableRoomsNumber
        case ByDistanceFromCenter
    }
    enum FilterOrder {
        case Ascending
        case Descending
    }
    
    let type: FilteringType
    let order: FilterOrder
    
    
    init(filterControlSegment: Int, orderControlSegment: Int) {
        
        switch (filterControlSegment, orderControlSegment) {
        case (0, 0):
            self.type = .ByAvailableRoomsNumber
            self.order = .Ascending
        case (0, 1):
            self.type = .ByAvailableRoomsNumber
            self.order = .Descending
        case (1, 0):
            self.type = .ByDistanceFromCenter
            self.order = .Ascending
        case (1, 1):
            self.type = .ByDistanceFromCenter
            self.order = .Descending
        case (_, _):
            self.type = .ByAvailableRoomsNumber
            self.order = .Ascending
        }
        
    }
    
}


