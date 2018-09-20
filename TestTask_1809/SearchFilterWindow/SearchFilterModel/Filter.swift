//
//  SortFilter.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


//enum FilteringType  {
//
//    var settings: (type: FilteringType, ascending: Bool) {
//        return (self, isAscending)
//    }
//
//
//    private var isAscending: Bool {
//        switch self {
//        case .ByAvailableRoomsNumber(order: let orderType):
//            return (orderType == .Ascending ? true : false)
//        case .ByDistanceFromCenter(order: let orderType):
//            return (orderType == .Ascending ? true : false)
//
//        }
//    }
//    case ByAvailableRoomsNumber(order: OrderType)
//    case ByDistanceFromCenter(order: OrderType)
//
//    enum OrderType {
//        case Ascending
//        case Descending
//    }
//
//
//    static func buildFilter(fromFilterSegmentedControl firstSegment: Int, orderSegmentControl secondSegment: Int) -> FilteringType {
//        switch (firstSegment, secondSegment) {
//        case (0, 0):
//            return FilteringType.ByAvailableRoomsNumber(order: .Ascending)
//        case (0, 1):
//            return FilteringType.ByAvailableRoomsNumber(order: .Descending)
//        case (1, 0):
//            return FilteringType.ByDistanceFromCenter(order: .Ascending)
//        case (1, 1):
//            return FilteringType.ByDistanceFromCenter(order: .Descending)
//        case (_, _):
//            return FilteringType.ByAvailableRoomsNumber(order: .Ascending)
//        }
//    }
//
//}



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


