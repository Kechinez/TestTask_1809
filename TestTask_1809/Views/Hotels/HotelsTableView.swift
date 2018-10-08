//
//  HotelsTableView.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class HotelsTableView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let background = UIView()
        background.backgroundColor = #colorLiteral(red: 0.03418464472, green: 0.03418464472, blue: 0.03418464472, alpha: 1)
        tableView.backgroundView = background
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorColor = #colorLiteral(red: 0.9877062183, green: 0.9068514552, blue: 0.4717055176, alpha: 1)
        tableView.register(HotelCell.self, forCellReuseIdentifier: "HotelCell")
        return tableView
    }()
    
    
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        setupConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    //MARK: - Additional methods
    
    func setupDelegateAndDataSource(vc: HotelsTableViewController) {
        self.tableView.delegate = vc
        self.tableView.dataSource = vc
    }
    

    private func setupConstraints() {
        
        if #available(iOS 11, *) {
            let guide = self.safeAreaLayoutGuide
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            
        } else {
            let margins = self.layoutMarginsGuide
            let standardSpacing: CGFloat = 8.0
            tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: standardSpacing).isActive = true
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: standardSpacing).isActive = true
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            
        }
    }
    
}
