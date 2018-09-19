//
//  HotelCell.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: 17)
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: 13)
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        return label
    }()
    let markerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "markerIcon.png")
        imageView.tintColor = .white
        return imageView
    }()
    
//    let roomLeftLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        let fontSize = CGFloat.calculateFontSize(from: 13)
//        label.font = UIFont(name: "OpenSans", size: fontSize)!
//        label.textColor = .white
//        return label
//    }()
    let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fill
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 7
        return stackView
    }()
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        print(self.frame)
        
        self.addSubview(nameLabel)
        self.addSubview(distanceLabel)
        //self.addSubview(roomLeftLabel)
        self.addSubview(starsStackView)
        self.addSubview(markerImage)
        createStarsArray()
        setupConstraints()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func showHotelStars(_ stars: Int) {
        for (index, star) in starsStackView.arrangedSubviews.enumerated() {
            if index < stars {
                star.alpha = 1.0
            } else {
                star.alpha = 0.3
            }
        }
    }
    
    
    private func createStarsArray() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.image = UIImage(named: "starIcon.png")
            starImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
            starsStackView.addArrangedSubview(starImageView)
        }
    }
    
    
    private func setupConstraints() {
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        starsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        starsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 10).isActive = true
        
        markerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        markerImage.heightAnchor.constraint(equalTo: distanceLabel.heightAnchor, multiplier: 1.2).isActive = true
        markerImage.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -7).isActive = true
        markerImage.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor).isActive = true
        
        //.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10).isActive = true
        //roomLeftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
    }
    
    
}



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




