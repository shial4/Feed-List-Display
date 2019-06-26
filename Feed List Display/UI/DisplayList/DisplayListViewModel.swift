//
//  DisplayListViewModel.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol DisplayListViewCoordinator: Coordinator {
    func fetchData(_ callback: @escaping (RequestResult<[Post], Error>) -> Void)
    func notifyUpdate() throws
    func setToPreview(_ value: Post)
}

class DisplayListViewModel: ViewModel {
    typealias ControllerType = DisplayListViewController
    private var controller: DisplayListViewController!
    private var coordinator: DisplayListViewCoordinator!
    private(set) var data: BehaviorRelay<[Post]>
    private var token: NotificationToken!
    
    deinit {
        token.invalidate()
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
        self.data = BehaviorRelay(value: data)
        self.token = Post.subscribe(try Realm(), callback: { [weak self] _ in
            do {
                try self?.coordinator.notifyUpdate()
            } catch let throwError {
                self?.coordinator.show(throwError)
            }
        })
    }
    
    func update(model: Any?) throws {
        guard let posts = model as? [Post] else {
            throw CoordinatorError.modelTypeMismatch
        }
        self.data.accept(Array(Set(data.value + posts)))
    }
    
    func showDetails(_ post: Post) {
        coordinator.setToPreview(post)
    }
    
    func refreshData(_ control: UIRefreshControl) {
        coordinator.fetchData { result in
            DispatchQueue.main.async {
                control.endRefreshing()
                switch result {
                case .success(_):
                    break //Changes will be update thru realm notification
                case .failure(let error):
                    self.coordinator.show(error)
                }
            }
        }
    }
}
