//
//  DogListDetailAssembler.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

protocol DogDetailAssemblerProtocol {
    static func resolveViewController(with dog: Dog) -> UIViewController
    static func resolvePresenter(viewController: DogDetailViewControllerProtocol, router: DogDetailRouterProtocol, dog: Dog) -> DogDetailPresenterProtocol
}

class DogDetailAssembler: DogDetailAssemblerProtocol {

    static func resolveViewController(with dog: Dog) -> UIViewController {
        
        let viewController = DogDetailViewController()
        let router = DogDetailRouter(navigationController: viewController.navigationController ?? UINavigationController())

        let presenter = resolvePresenter(viewController: viewController, router: router, dog: dog)
        viewController.presenter = presenter
        
        return viewController
    }
    
    static func resolvePresenter(viewController: DogDetailViewControllerProtocol, router: DogDetailRouterProtocol, dog: Dog) -> DogDetailPresenterProtocol {
        let interactor = DogDetailInteractor()
        return DogDetailPresenter(viewController: viewController,
                                        interactor: interactor,
                                        router: router,
                                        dog: dog)
    }
}
