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
        
    
    func setupDelegateAndDataSource(vc: HotelsTableViewController) {
        self.tableView.delegate = vc
        self.tableView.dataSource = vc
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
