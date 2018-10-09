//
//  HotelCell.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 19.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelCell: UITableViewCell {
    
    //MARK: - Creating UI
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTextAppearance(with: 17)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label
    }()
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTextAppearance(with: CGFloat.calculateFontSize(from: 13))
        return label
    }()
    private let markerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "markerIcon.png")
        imageView.tintColor = .white
        return imageView
    }()
    private let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fill
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 7
        return stackView
    }()
    
    //MARK: - Binding
    var hotelViewModel: HotelViewModel {
        didSet {
            updateUI()
        }
    }
    
    
    
    //MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        print(self.frame)
        self.addSubview(nameLabel)
        self.addSubview(distanceLabel)
        self.addSubview(starsStackView)
        self.addSubview(markerImage)
        createStarsArray()
        setupConstraints()
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - Additional methods
    
    func updateUI() {
        self.nameLabel.text = currentHotel.name
        self.distanceLabel.text = currentHotel.distanceString
        showHotelStars(currentHotel.stars)
        
    }


    private func showHotelStars(_ stars: Int) {
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
        distanceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        markerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        markerImage.heightAnchor.constraint(equalTo: distanceLabel.heightAnchor, multiplier: 1.2).isActive = true
        markerImage.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -7).isActive = true
        markerImage.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor).isActive = true
        
    }
    
    
}







