//
//  DogListDetailAssembler.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

protocol DogListDetailAssemblerProtocol {
    static func resolveViewController() -> UIViewController
    static func resolvePresenter(viewController: DogListDetailViewControllerProtocol, router: DogListDetailRouterProtocol) -> DogListDetailPresenterProtocol
}

class DogListDetailAssembler: DogListDetailAssemblerProtocol {

    static func resolveViewController() -> UIViewController {
        
        let viewController = DogListDetailViewController(style: .insetGrouped)
        let navigationController = UINavigationController(rootViewController: viewController)
        let router = DogListDetailRouter(navigationController: navigationController)

        let presenter = resolvePresenter(viewController: viewController, router: router)
        viewController.presenter = presenter
        
        return navigationController
    }
    
    static func resolvePresenter(viewController: DogListDetailViewControllerProtocol, router: DogListDetailRouterProtocol) -> DogListDetailPresenterProtocol {
        let repository = DogsRepository()
        let interactor = DogListDetailInteractor(repository: repository)

        return DogListDetailPresenter(viewController: viewController,
                                        interactor: interactor,
                                        router: router)
    }
}
