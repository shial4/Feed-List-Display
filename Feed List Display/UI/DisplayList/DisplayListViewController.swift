//
//  DisplayListViewController.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import UIKit

class DisplayListViewController: TableViewController {
    typealias ViewModelType = DisplayListViewModel
    var viewModel: DisplayListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding foother, to prevent display of empty section/rows separators
        tableView.tableFooterView = UIView()
    }
}

