//
//  PsevdoView.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 21.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import MapKit



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
        imageView.backgroundColor = UIColor.clear
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
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private var hotelImageHeightConstraint: NSLayoutConstraint?
    private var mapViewHeightConstraint: NSLayoutConstraint?
    private var mapViewWidthConstraint: NSLayoutConstraint?
    private var isHotelImageFailedDownload = false
    
    
    
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
        scrollView.addSubview(activityIndicator)
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
    
    
    func hideHotelImageFrame() {
        isHotelImageFailedDownload = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        hotelImageHeightConstraint?.isActive = false
        hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalToConstant: 0)
        hotelImageHeightConstraint?.isActive = true
        //hotelImageHeightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
    }
    
    
    
    
    func setImage(with image: UIImage) {
        activityIndicator.stopAnimating()
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
            
            if !isHotelImageFailedDownload {
                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
                hotelImageHeightConstraint!.isActive = true
            }
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            
        } else {
            
            if !isHotelImageFailedDownload {
                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
                hotelImageHeightConstraint!.isActive = true
            }

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
            
            if !isHotelImageFailedDownload {
                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
                hotelImageHeightConstraint!.isActive = true
            }
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
            mapViewHeightConstraint!.isActive = true
            
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.6)
            mapViewWidthConstraint!.isActive = true
        } else {
            if !isHotelImageFailedDownload {
                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
                hotelImageHeightConstraint!.isActive = true
            }
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
            addressLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30).isActive = true
            addressLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
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
            addressLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
            addressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
            mapViewHeightConstraint!.isActive = true
            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
            mapViewWidthConstraint!.isActive = true
            mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        
        hotelImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
    
        starsStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        starsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        
        roomLeftLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 15).isActive = true
        roomLeftLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        
        mapView.topAnchor.constraint(equalTo: roomLeftLabel.bottomAnchor, constant: 30).isActive = true
        mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: hotelImage.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: hotelImage.centerXAnchor).isActive = true
    }
    
    
    func setupMapDelegate(with corespondingController: CurrentHotelController) {
                mapView.delegate = corespondingController
            }
    
    
        
    
    
            func setLocation(with coordinates: CLLocationCoordinate2D) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                mapView.showAnnotations([annotation], animated: true)
        
            }
    
    
}















//class CurrentHotelView: UIView, MKMapViewDelegate {
//
//    let scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        let fontSize = CGFloat.calculateFontSize(from: 22)
//        label.font = UIFont(name: "OpenSans", size: fontSize)!
//        label.textColor = .white
//        label.numberOfLines = 2
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.sizeToFit()
//        return label
//    }()
//    let starsStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = UILayoutConstraintAxis.horizontal
//        stackView.distribution = UIStackViewDistribution.fill
//        stackView.alignment = UIStackViewAlignment.fill
//        stackView.spacing = 10
//        return stackView
//    }()
//    let addressLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        let fontSize = CGFloat.calculateFontSize(from: 14)
//        label.font = UIFont(name: "OpenSans", size: fontSize)!
//        label.textColor = .white
//        label.numberOfLines = 2
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.sizeToFit()
//        return label
//    }()
//    let roomLeftLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        let fontSize = CGFloat.calculateFontSize(from: 17)
//        label.font = UIFont(name: "OpenSans", size: fontSize)!
//        label.textColor = .white
//        return label
//    }()
//    let hotelImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.clear
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    let mapView: MKMapView = {
//        let map = MKMapView()
//        map.layer.cornerRadius = 8
//        map.translatesAutoresizingMaskIntoConstraints = false
//        return map
//    }()
//    let activityIndicator: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        return activityIndicator
//    }()
//    private var hotelImageHeightConstraint: NSLayoutConstraint?
//    private var mapViewHeightConstraint: NSLayoutConstraint?
//    private var mapViewWidthConstraint: NSLayoutConstraint?
//    private var nameLabelTopConstraint: NSLayoutConstraint?
//
//
//
//    func startActivityIndicator() {
//        //scrollView.addSubview(activityIndicator)
//        //setUpActivityIndicatorConstraints()
//        activityIndicator.startAnimating()
//    }
//
//
//
//
//
////    private func setupHotelImageConstraints() {
////
////        activityIndicator.stopAnimating()
////        //activityIndicator.removeFromSuperview()
////        let c = activityIndicator.constraints
////        activityIndicator.removeConstraints(c)
////        activityIndicator.removeFromSuperview()
////
////
////
////
////        //nameLabel.removeConstraint(nameLabelTopConstraint!)
////        nameLabelTopConstraint!.isActive = false
////        nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 30)
////        nameLabelTopConstraint!.isActive = true
////
////
////
////        hotelImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
////
////        if #available(iOS 11, *) {
////            let safeArea = self.safeAreaLayoutGuide
////
////           // scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
////            hotelImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
////            hotelImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
////            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
////            hotelImageHeightConstraint!.isActive = true
////        } else {
////            hotelImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
////            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
////            hotelImageHeightConstraint!.isActive = true
////        }
////
////
////        //hotelImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
////
////        UIView.animate(withDuration: 0.3, animations: {
////            self.layoutIfNeeded()
////        }) { (bool) in
////
////        }
////    }
//
////    private func setUpActivityIndicatorConstraints() {
////        if #available(iOS 11, *) {
////
////            let safeArea = self.safeAreaLayoutGuide
////            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
////            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
////
////        } else {
////            activityIndicator.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
////            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
////        }
////        //activityIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
////        //activityIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
////        nameLabelTopConstraint?.constant = 100
////        ////nameLabelTopConstraint!.isActive = false
////        //nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 30)
////        //nameLabelTopConstraint!.isActive = true
////
//////        UIView.animate(withDuration: 0.3) {
//////            self.layoutIfNeeded()
//////        }
////    }
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
//        self.addSubview(scrollView)
//        scrollView.addSubview(nameLabel)
//        scrollView.addSubview(starsStackView)
//        scrollView.addSubview(roomLeftLabel)
//        scrollView.addSubview(addressLabel)
//        scrollView.addSubview(mapView)
//        scrollView.addSubview(hotelImage)
//        scrollView.addSubview(activityIndicator)
//        createStarsArray()
//        setupConstraints()
//
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func setupMapDelegate(with corespondingController: CurrentHotelController) {
//        mapView.delegate = corespondingController
//    }
//
//
//
//    func updateUI(with hotelData: Hotel) {
//        self.nameLabel.text = hotelData.name
//        self.addressLabel.text = hotelData.address
//        self.roomLeftLabel.text = hotelData.roomsAvailableString
//        self.showHotelStars(hotelData.stars)
//
//
//
//    }
//
//
//
//    func setLocation(with coordinates: CLLocationCoordinate2D) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinates
//        mapView.showAnnotations([annotation], animated: true)
//
//    }
//
//
//    func setImage(with image: UIImage) {
//        //scrollView.addSubview(hotelImage)
//        //setupHotelImageConstraints()
//        activityIndicator.stopAnimating()
//
//        let imageWithoutRedBounds = image.croppedRedBounds()
//        self.hotelImage.image = imageWithoutRedBounds
//    }
//
//
//    func showHotelStars(_ stars: Int) {
//        for (index, star) in starsStackView.arrangedSubviews.enumerated() {
//            if index < stars {
//                star.alpha = 1.0
//            } else {
//                star.alpha = 0.3
//            }
//        }
//    }
//
//
//    private func createStarsArray() {
//        for _ in 0..<5 {
//            let starImageView = UIImageView()
//            starImageView.translatesAutoresizingMaskIntoConstraints = false
//            starImageView.image = UIImage(named: "starIcon.png")
//            starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
//            starImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
//            starsStackView.addArrangedSubview(starImageView)
//        }
//    }
//
//
//
//    func updateConstraintsForPortraitMode() {
//
//        hotelImageHeightConstraint?.isActive = false
//        mapViewWidthConstraint?.isActive = false
//        mapViewHeightConstraint?.isActive = false
//
//        if #available(iOS 11, *) {
//            let safeArea = self.safeAreaLayoutGuide
//
//            if hotelImageHeightConstraint != nil {
//                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
//                hotelImageHeightConstraint!.isActive = true
//            }
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
//            mapViewHeightConstraint!.isActive = true
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30)
//            mapViewWidthConstraint!.isActive = true
//            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
//
//        } else {
//
//            if hotelImageHeightConstraint != nil {
//                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
//                hotelImageHeightConstraint!.isActive = true
//            }
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
//            mapViewHeightConstraint!.isActive = true
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
//            mapViewWidthConstraint!.isActive = true
//        }
//
//    }
//
//
//    func updateConstraintsForLandcapeMode() {
//        hotelImageHeightConstraint?.isActive = false
//       mapViewWidthConstraint?.isActive = false
//        mapViewHeightConstraint?.isActive = false
//
//        if #available(iOS 11, *) {
//            let safeArea = self.safeAreaLayoutGuide
//
//            if hotelImageHeightConstraint != nil {
//                //hotelImageHeightConstraint!.isActive = false
//                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
//                hotelImageHeightConstraint!.isActive = true
//
//
//
//            }
//            //mapViewHeightConstraint!.isActive = false
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
//            mapViewHeightConstraint!.isActive = true
//
//            mapViewWidthConstraint!.isActive = true
//
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.6)
//            mapViewWidthConstraint!.isActive = true
//
//        } else {
//            if hotelImageHeightConstraint != nil {
//                hotelImageHeightConstraint!.isActive = false
//
//                hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
//                hotelImageHeightConstraint!.isActive = true
//
//            }
//            mapViewHeightConstraint!.isActive = false
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor)
//            mapViewHeightConstraint!.isActive = true
//
//            mapViewWidthConstraint!.isActive = false
//
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
//            mapViewWidthConstraint!.isActive = true
//        }
//
//    }
//
//
//
//    private func setupConstraints() {
//
//        if #available(iOS 11, *) {
//            let safeArea = self.safeAreaLayoutGuide
//            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
//            scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor).isActive = true
//            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
//            //scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
//
//            //hotelImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//            hotelImage.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
//            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4)
//            hotelImageHeightConstraint!.isActive = true
//
//            nameLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30).isActive = true
//            nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
//            //nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20)
//            //nameLabelTopConstraint!.isActive = true
//
//            addressLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30).isActive = true
//            addressLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
//            mapViewHeightConstraint!.isActive = true
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30)
//            mapViewWidthConstraint!.isActive = true
//            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
//
//        } else {
//            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//            scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//
//            hotelImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//            hotelImageHeightConstraint = hotelImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
//            hotelImageHeightConstraint!.isActive = true
//
//            //nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20)
//            //nameLabelTopConstraint!.isActive = true
//            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
//            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//            addressLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
//            addressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//            mapViewHeightConstraint = mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
//            mapViewHeightConstraint!.isActive = true
//            mapViewWidthConstraint = mapView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)
//            mapViewWidthConstraint!.isActive = true
//            mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        }
//
//        hotelImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        hotelImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        hotelImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//
//
//        nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20)
//        nameLabelTopConstraint!.isActive = true
//
//        //nameLabel.topAnchor.constraint(equalTo: hotelImage.bottomAnchor, constant: 20).isActive = true
//        //nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20)
//        //nameLabelTopConstraint?.isActive = true
//
//
//        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
//
//        starsStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
//        starsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
//
//        roomLeftLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 15).isActive = true
//        roomLeftLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
//
//        mapView.topAnchor.constraint(equalTo: roomLeftLabel.bottomAnchor, constant: 30).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
//
//        activityIndicator.centerXAnchor.constraint(equalTo: hotelImage.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: hotelImage.centerYAnchor).isActive = true
//
//
//    }
//
//
//
//}
