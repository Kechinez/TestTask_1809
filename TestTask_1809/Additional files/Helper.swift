//
//  Helper.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 21.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    static func calculateFontSize(from originalSize: CGFloat) -> CGFloat {
        var deviceWidth: CGFloat = 0.0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                deviceWidth = 320         //iPhone 5 or 5S or 5C
            case 1334, 2436:
                deviceWidth = 375          // iPhone 6/6S/7/8/X
            case 1920, 2208:
                deviceWidth = 414          // iPhone 6+/6S+/7+/8+
            default:
                deviceWidth = 320
            }
        }
        return originalSize / 320 * deviceWidth
    }
}


extension Array where Array == [Hotel] {
    
    mutating func sortHotels(using filter: Filter) {
        
        if filter.type == .ByAvailableRoomsNumber {
            switch filter.order {
            case .Ascending:
                self.sort { $0.roomsAvailable < $1.roomsAvailable }
            case .Descending:
                self.sort { $0.roomsAvailable > $1.roomsAvailable }
            }
        } else {
            switch filter.order {
            case .Ascending:
                self.sort { $0.distance < $1.distance }
            case .Descending:
                self.sort { $0.distance > $1.distance }
            }
        }
        return
    }
}



extension UIImage {
    func croppedRedBounds() -> UIImage {
        var rect = CGRect.zero
        
        switch self.scale {
        case 1.0:
            rect = CGRect(x: 1, y: 1, width: self.size.width - 2, height: self.size.height - 2)
        case 2.0:
            rect = CGRect(x: 0.5, y: 0.5, width: self.size.width - 1, height: self.size.height - 1)
        case 3.0:
            rect = CGRect(x: 1 / 3, y: 1 / 3, width: self.size.width - (1 / 3) * 2, height: self.size.height - (1 / 3) * 2)
        default:
            break
        }
        
        let contextImage = self.cgImage
        let imageRef: CGImage = contextImage!.cropping(to: rect)!
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}



extension UILabel {
    func setTextAppearance(with textSize: CGFloat) {
        let fontSize = CGFloat.calculateFontSize(from: CGFloat.calculateFontSize(from: textSize))
        self.font = UIFont(name: "OpenSans", size: fontSize)!
        self.textColor = .white
    }
}





