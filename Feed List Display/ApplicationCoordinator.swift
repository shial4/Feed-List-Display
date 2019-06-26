//
//  AppDelegate.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// Helper typealias for future UIViewController which are part of coordinator patter.
typealias ViewController = UIViewController & Controller
// Helper typealias for future UITableViewController which are part of coordinator patter.
typealias TableViewController = UITableViewController & Controller
// Default delcaration of Coordinator.
protocol Coordinator {
    func show(_ error: Error)
    func alert(title: String, message: String?)
}
// Default protocol for ViewModel. Created for eas of use
protocol ViewModel {
    associatedtype ControllerType: Controller
    init(controller: ControllerType, coordinator: Coordinator, model: Any?) throws
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

extension CoordinatorError: LocalizedError {
    var errorDescription: String? {
        return "\(self)".unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0!.count > 0 {
                    return ($0! + " " + String($1).lowercased())
                }
            }
            return $0! + String($1)
        }
    }
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
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
    }
    /**
     Method invoked only once during app lunch. ALl necessary setup for the application is done here. If that would take more then ten seconds. It would be smart to introduce the middle controller with a loader or some kind of animation to do the heavy lifting over there. Once that would be completed we would proceed as normal. However, for this example, that's more than enough.
     */
    func start() {
        setToList(getLocalData())
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
        if let controller: T = existingViewController() {
            try controller.viewModel.update(model:model)
            return controller
        }
        guard let controller: T = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(T.classForCoder())Id") as? T else {
            throw CoordinatorError.storyboardTypeMismatch
        }
        controller.viewModel = try T.ViewModelType.init(controller: controller as! T.ViewModelType.ControllerType, coordinator: self, model: model)
        return controller
    }
    /*
     At this point we are ineterested in updating values for given VC
     */
    func existingViewController<T: UIViewController>() -> T? {
        for item in navigationController.viewControllers {
            if let viewController = item as? T {
                return viewController
            }
        }
        return nil
    }
    /**
     First flow method, moving user to Main screen which presents map with notes as pins.
     */
    func setToList(_ values: [Post]) {
        do {
            let controller: DisplayListViewController = try viewController(values)
            navigationController.pushViewController(controller, animated: false)
        } catch let error {
            show(error)
        }
    }
}

extension ApplicationCoordinator: DisplayListViewCoordinator {
    func getLocalData() -> [Post] {
        do {
            let posts = Post.getAll(try Realm())
            //For purpose of this (cus it is small list and all) we will skip paginations and subscriptions. Lets just assume it is all there. Here we will simply get the values from realm database.
            return posts.map({ $0 })
        } catch let error {
            show(error)
        }
        return []
    }
    
    func fetchData(_ callback: @escaping (RequestResult<[Post], Error>) -> Void) {
        //Featch new post from server
        _ = Application.featchPosts { values, error in
            guard let data = values, error == nil else {
                return callback(.failure(error!))
            }
            do {
                try Post.update(try Realm(), sequance: data)
            } catch let throwError {
                return callback(.failure(throwError))
            }
            return callback(.success(data))
        }
    }
    
    func notifyUpdate() throws {
        //Update model
        let _: DisplayListViewController? = try self.viewController(getLocalData())
    }
}
