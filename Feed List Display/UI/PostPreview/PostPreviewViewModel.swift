//
//  PostPreviewViewModel.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import Kingfisher

protocol PostPreviewViewCoordinator: Coordinator {}

class PostPreviewViewModel: ViewModel {
    typealias ControllerType = PostPreviewViewController
    private var controller: PostPreviewViewController!
    private var coordinator: PostPreviewViewCoordinator!
    private(set) var post: Post
    
    required init(controller: PostPreviewViewController, coordinator: Coordinator, model: Any?) throws {
        guard let coord = coordinator as? PostPreviewViewCoordinator else {
            throw CoordinatorError.coordinatorTypeMismatch
        }
        guard let post = model as? Post else {
            throw CoordinatorError.modelTypeMismatch
        }
        self.coordinator = coord
        self.controller = controller
        self.post = post
    }
    
    func update(model: Any?) throws {
        guard let post = model as? Post else {
            throw CoordinatorError.modelTypeMismatch
        }
        self.post = post
    }
    
    func configure() {
        let url = URL(string: post.imageUrl)
        controller.imageView.kf.indicatorType = .activity
        controller.imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        controller.textView.text = post.body
        controller.title = post.title
    }
}
