//
//  DogListAssembler.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 04/08/2023.
//

import UIKit

protocol DogListAssemblerProtocol {
    static func resolveViewController() -> UIViewController
    static func resolvePresenter(viewController: DogListViewControllerProtocol, router: DogListRouterProtocol) -> DogListPresenterProtocol
}

class DogListAssembler: DogListAssemblerProtocol {
    private static let mainStoryboard: String = "Main"
    private static let homeViewControllerIdentifier = "Home"
    
    static func resolveViewController() -> UIViewController {
        
        let viewController = DogListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let router = DogListRouter(navigationController: navigationController)

        let presenter = resolvePresenter(viewController: viewController, router: router)
        viewController.presenter = presenter
        
        return navigationController
    }
    
    static func resolvePresenter(viewController: DogListViewControllerProtocol, router: DogListRouterProtocol) -> DogListPresenterProtocol {
        let repository = DogsRepository()
        let interactor = DogListInteractor(repository: repository)

        return DogListPresenter(viewController: viewController,
                                        interactor: interactor,
                                        router: router)
    }
}
