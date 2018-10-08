//
//  SortFilter.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


struct Filter {

    enum FilteringType: Int {
        case ByAvailableRoomsNumber   = 0
        case ByDistanceFromCenter     = 1
    }
    enum FilterOrder: Int {
        case Ascending   = 0
        case Descending  = 1
    }
    
    let type: FilteringType
    let order: FilterOrder
    
    
    
    init(controlStates: (filterControlSegment: Int, filterControlSegment: Int)) {
        
        switch controlStates {
        case (FilteringType.ByAvailableRoomsNumber.rawValue, FilterOrder.Ascending.rawValue):
            self.type = .ByAvailableRoomsNumber
            self.order = .Ascending
        
        case (FilteringType.ByAvailableRoomsNumber.rawValue, FilterOrder.Descending.rawValue):
            self.type = .ByAvailableRoomsNumber
            self.order = .Descending
        
        case (FilteringType.ByDistanceFromCenter.rawValue, FilterOrder.Ascending.rawValue):
            self.type = .ByDistanceFromCenter
            self.order = .Ascending
        
        case (FilteringType.ByDistanceFromCenter.rawValue, FilterOrder.Descending.rawValue):
            self.type = .ByDistanceFromCenter
            self.order = .Descending
        case (_, _):
            self.type = .ByAvailableRoomsNumber
            self.order = .Ascending
        }
    }
    
}


