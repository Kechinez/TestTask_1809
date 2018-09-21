//
//  SearchFilterView.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchFilterView: UIView {

    let orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter hotels by"
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = CGFloat.calculateFontSize(from: CGFloat.calculateFontSize(from: 17))
        label.font = UIFont(name: "OpenSans", size: fontSize)!
        label.textColor = .white
        return label
    }()
    let filterControl: UISegmentedControl = {
        let items = ["rooms available", "distance from the center"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = #colorLiteral(red: 1, green: 0.9211425781, blue: 0.07194010417, alpha: 1)
        segmentedControl.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        segmentedControl.layer.cornerRadius = 5
        return segmentedControl
    }()
    let orderControl: UISegmentedControl = {
        let items = ["ascending order", "descending order"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = #colorLiteral(red: 1, green: 0.9211425781, blue: 0.07194010417, alpha: 1)
        segmentedControl.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        segmentedControl.layer.cornerRadius = 5
        return segmentedControl
    }()
    let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9211425781, blue: 0.07194010417, alpha: 1)
        let titleFont = UIFont(name: "OpenSans", size: CGFloat.calculateFontSize(from: 24))
        let attributesDictionary: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): titleFont!]
        let atrTitle = NSAttributedString(string: "Apply", attributes: attributesDictionary)
        button.setAttributedTitle(atrTitle, for: .normal)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        self.addSubview(applyButton)
        self.addSubview(filterControl)
        self.addSubview(orderLabel)
        self.addSubview(orderControl)
        
        setupConstraints()
    }
    
    
    func addActionToButton(relatedTo viewController: SearchFilterController) {
        applyButton.addTarget(viewController, action: #selector(SearchFilterController.applySearchFilter), for: .touchUpInside)
    }
    
    
    private func setupConstraints() {
        
        if #available(iOS 11, *) {
            let guide = self.safeAreaLayoutGuide
            orderLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30).isActive = true

            filterControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            filterControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true

            applyButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
            applyButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.35).isActive = true
            
        } else {
            orderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
            
            filterControl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            filterControl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            
            applyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            applyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35).isActive = true
            
        }
        
        orderLabel.leadingAnchor.constraint(equalTo: filterControl.leadingAnchor).isActive = true

        filterControl.topAnchor.constraint(equalTo: orderLabel.bottomAnchor, constant: 10).isActive = true

        orderControl.topAnchor.constraint(equalTo: filterControl.bottomAnchor, constant: 20).isActive = true
        orderControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        orderControl.widthAnchor.constraint(equalTo: filterControl.widthAnchor).isActive = true

        applyButton.topAnchor.constraint(equalTo: orderControl.bottomAnchor, constant: 40).isActive = true
        applyButton.heightAnchor.constraint(equalTo: filterControl.heightAnchor, multiplier: 1.4).isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
