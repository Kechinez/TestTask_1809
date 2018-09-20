//
//  CurrentHotelView.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import MapKit
class CurrentHotelView: UIScrollView {

    let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: 22)
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fill
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 10
        return stackView
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: 14)
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    let roomLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: 17)
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        return label
    }()
    let hotelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        self.addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starsStackView)
        contentView.addSubview(roomLeftLabel)
        contentView.addSubview(hotelImage)
        contentView.addSubview(addressLabel)
        contentView.addSubview(mapView)
        
        createStarsArray()
        setupConstraints()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func updateUI(with hotelData: Hotel) {
        self.nameLabel.text = hotelData.name
        self.addressLabel.text = hotelData.address
        self.roomLeftLabel.text = hotelData.roomsAvailableString
        self.showHotelStars(hotelData.stars)
        
        
        
    }
    
    
    
    func setImage(with image: UIImage) {
        self.hotelImage.image = image
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
            starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
            starsStackView.addArrangedSubview(starImageView)
        }
    }
    
    
    private func setupConstraints() {
        
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        hotelImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hotelImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hotelImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        hotelImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        starsStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        starsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        roomLeftLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 15).isActive = true
        roomLeftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        mapView.topAnchor.constraint(equalTo: roomLeftLabel.bottomAnchor, constant: 30).isActive = true
        mapView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
    }

    
    
}
