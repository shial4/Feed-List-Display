//
//  AppDelegate.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import UIKit

// Helper typealias for future UIViewController which are part of coordinator patter.
typealias ViewController = UIViewController & Controller
// Helper typealias for future UITableViewController which are part of coordinator patter.
typealias TableViewController = UITableViewController & Controller
// Default delcaration of Coordinator.
protocol Coordinator {
    var application: Application { get }
    func show(_ error: Error)
    func alert(title: String, message: String?)
}
// Default protocol for ViewModel. Created for eas of use
protocol ViewModel {
    associatedtype ControllerType: Controller
    init(controller: ControllerType, coordinator: Coordinator, model: Any?) throws
    func configure()
    func update(model: Any?) throws
}
// Controller protocol created for purpose of MVVM patter.
protocol Controller: UIViewController {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}
// Error type which may occur during configuration or flow sequences
enum CoordinatorError: Error {
    case storyboardTypeMismatch
    case coordinatorTypeMismatch
    case modelTypeMismatch
}

//Main coordinator class. Implementing other coordinators protocols and flow operations.
class ApplicationCoordinator: Coordinator {
    /**
     We do hold window reference from our application in here as a weak variable.
     Just in case, not to fall in a retain cycle.
     */
    private weak var window: UIWindow?
    /**
     Main UINavigationController of application which will act as a root controller.
     */
    lazy var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    /// Referance of Application for easy access from our VM instances.
    lazy var application: Application = Application()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
    }
    /**
     Method invoked only once during app lunch. ALl necessary setup for the application is done here. If that would take more then ten seconds. It would be smart to introduce the middle controller with a loader or some kind of animation to do the heavy lifting over there. Once that would be completed we would proceed as normal. However, for this example, that's more than enough.
     */
    func start() {
        setToList()
    }
    /**
     Alert helper method helps present message to the application user.
     */
    func alert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        navigationController.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows alert with use of above helper when ever error needs to be presented.
     */
    func show(_ error: Error) {
        alert(title: error.localizedDescription)
    }
    
    /**
     Generic helper method to instantiate ViewController based on the return type.
     In this example it is simple due to we have single storyboard and for eas of use we do keep convention that viewController ids are constructed as follow:
     ```
     ViewController.Type + "Id"
     ```
     */
    func viewController<T: Controller>(_ model: Any?) throws -> T {
        if let controller: T = navigationController.viewControllers.last as? T {
            try controller.viewModel.update(model:model)
        }
        guard let controller: T = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(T.classForCoder())Id") as? T else {
            throw CoordinatorError.storyboardTypeMismatch
        }
        controller.viewModel = try T.ViewModelType.init(controller: controller as! T.ViewModelType.ControllerType, coordinator: self, model: model)
        return controller
    }
    /**
     First flow method, moving user to Main screen which presents map with notes as pins.
     */
    func setToList() {
        do {
            let controller: DisplayListViewController = try viewController(nil)
            navigationController.pushViewController(controller, animated: false)
        } catch let error {
            show(error)
        }
    }
}
