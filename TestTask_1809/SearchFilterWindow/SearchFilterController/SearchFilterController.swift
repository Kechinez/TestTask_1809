//
//  SearchFilterController.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 20.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchFilterController: UIViewController {

    weak var delegate: HotelsTableViewController?
    
    unowned var searchFilterView: SearchFilterView {
        return view as! SearchFilterView
    }
    
    override func loadView() {
        view = SearchFilterView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filter result"
        searchFilterView.addActionToButton(relatedTo: self)
        
    }

    
    @objc func applySearchFilter() {
        let filterControlSegment = searchFilterView.filterControl.selectedSegmentIndex
        let orderControlSegment = searchFilterView.orderControl.selectedSegmentIndex
        let filter = Filter(filterControlSegment: filterControlSegment, orderControlSegment: orderControlSegment)
        
        //let filter = FilteringType.buildFilter(fromFilterSegmentedControl: filterControlSegment, orderSegmentControl: orderControlSegment)
        delegate?.hotelFilter = filter
        
        navigationController?.popViewController(animated: true)
    }

}
