//
//  DogDetailPresenter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import Foundation

protocol DogDetailPresenterProtocol {
    func viewWillAppear()
}

class DogDetailPresenter: DogDetailPresenterProtocol {
    private let interactor:  DogDetailInteractorProtocol
    private let router:  DogDetailRouterProtocol
    private let viewController: DogDetailViewControllerProtocol
    private var dog: Dog

    init(viewController: DogDetailViewControllerProtocol,
         interactor: DogDetailInteractorProtocol,
         router: DogDetailRouterProtocol,
         dog: Dog) {
        self.viewController = viewController
        self.interactor = interactor
        self.router = router
        self.dog = dog
    }
    
    func viewWillAppear() {
        viewController.setDog(dog: dog)
    }
}
