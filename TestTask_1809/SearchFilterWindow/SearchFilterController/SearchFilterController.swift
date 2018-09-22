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
    
    
    
    //MARK: - ViewController lifecycle
    
    override func loadView() {
        view = SearchFilterView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filter result"
        searchFilterView.addActionToButton(relatedTo: self)
        
    }

   
    
    
    //MARK: - Additional methods
    
    @objc func applySearchFilter() {
        let controlStates = searchFilterView.getCurrentSegmentedControlsStates()
        let filter = Filter(controlStates: controlStates)
        delegate?.hotelFilter = filter
        navigationController?.popViewController(animated: true)
    }

}
