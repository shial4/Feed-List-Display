//
//  DisplayListViewModel.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation

protocol DisplayListViewCoordinator: Coordinator {
    func fetchData(_ callback: @escaping (Result<[Post], Error>) -> Void) 
}

class DisplayListViewModel: ViewModel {
    typealias ControllerType = DisplayListViewController
    private var controller: DisplayListViewController!
    private var coordinator: DisplayListViewCoordinator!
    private var workItem: DispatchWorkItem?
    private var data: [Post]? {
        didSet {
            configure()
        }
    }
    
    required init(controller: DisplayListViewController, coordinator: Coordinator, model: Any?) throws {
        guard let coord = coordinator as? DisplayListViewCoordinator else {
            throw CoordinatorError.coordinatorTypeMismatch
        }
        guard let data = model as? [Post] else {
            throw CoordinatorError.modelTypeMismatch
        }
        self.coordinator = coord
        self.controller = controller
        self.data = data
    }
    
    func update(model: Any?) throws {
        guard let user = model as? [Post] else {
            throw CoordinatorError.modelTypeMismatch
        }
        self.data = user
    }
    
    func configure() {
        controller.tableView.reloadData()
    }
}
