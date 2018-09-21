//
//  PsevdoView.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 21.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import MapKit



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





class CurrentHotelView: UIView {
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
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
        imageView.backgroundColor = UIColor.green
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private var hotelImageHeightConstraint: NSLayoutConstraint?
    private var mapViewHeightConstraint: NSLayoutConstraint?
    private var mapViewWidthConstraint: NSLayoutConstraint?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        self.addSubview(scrollView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(starsStackView)
        scrollView.addSubview(roomLeftLabel)
        scrollView.addSubview(hotelImage)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(mapView)
        
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
        let imageWithoutRedBounds = image.croppedRedBounds()
        self.hotelImage.image = imageWithoutRedBounds
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
    
    
    func updateConstraintsForPortraitMode() {
    
        hotelImageHeightConstraint!.isActive = false
        mapViewWidthConstraint!.isActive = false
        mapViewHeightConstraint!.isActive = false
        
        if #available(iOS 11, *) {
            let safeArea = self.safeAreaLayoutGuide
            
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            
        } else {
            
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
        }
        
    }
    
    
    func updateConstraintsForLandcapeMode() {
        hotelImageHeightConstraint!.isActive = false
        mapViewWidthConstraint!.isActive = false
        mapViewHeightConstraint!.isActive = false
        
        if #available(iOS 11, *) {
            let safeArea = self.safeAreaLayoutGuide
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
            mapViewHeightConstraint!.isActive = true

            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.6)
            mapViewWidthConstraint!.isActive = true
        } else {
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor)
            mapViewHeightConstraint!.isActive = true
            
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
            mapViewWidthConstraint!.isActive = true
        }
    }
    
    
    
    private func setupConstraints() {
        
        if #available(iOS 11, *) {
            let safeArea = self.safeAreaLayoutGuide
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
            
            hotelImage.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            nameLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30).isActive = true
            nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            
        } else {
            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            
            hotelImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
            hotelImageHeightConstraint!.isActive = true
            
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
            mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
       
        hotelImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true

        starsStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        starsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true

        roomLeftLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 15).isActive = true
        roomLeftLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        
        mapView.topAnchor.constraint(equalTo: roomLeftLabel.bottomAnchor, constant: 30).isActive = true
        mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true

    }
    
    
    
}
