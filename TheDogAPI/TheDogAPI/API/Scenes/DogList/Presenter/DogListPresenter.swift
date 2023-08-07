//
//  DogListPresenter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import Foundation

protocol DogListPresenterProtocol {
    func viewWillAppear()
    func didSelectRow(at indexPath: IndexPath)
    func fetchDogs(completion: @escaping ([Dog]?, Error?) -> Void)
}

class DogListPresenter: DogListPresenterProtocol {
    private let interactor:  DogListInteractorProtocol
    private let router:  DogListRouterProtocol
    private let viewController: DogListViewControllerProtocol
    private var dogs: [Dog]?
    
    init(viewController: DogListViewControllerProtocol,
         interactor: DogListInteractorProtocol,
         router: DogListRouterProtocol) {
        self.viewController = viewController
        self.interactor = interactor
        self.router = router
        
        viewController.showLoading(load: true)
        fetchDogs { dogs, error in
            if let error = error {
                print("Error: \(error)")
            } else if let dogs = dogs {
                self.dogs = dogs
                self.viewController.setDogs(dogs: dogs)
                self.viewController.showLoading(load: false)
            }
        }
    }
    
    func viewWillAppear() {
        viewController.setDogs(dogs: dogs ?? [])
    }

    func didSelectRow(at indexPath: IndexPath) {
        if let dog = dogs?[indexPath.row] {
            router.showDetail(dog: dog)
        } else {
            router.showAlert(with: "Error", message: "We could not find the dog details")
        }
    }
    
    func fetchDogs(completion: @escaping ([Dog]?, Error?) -> Void) {
        interactor.fetchDogs { dogs, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            } else if let dogs = dogs {
                print("Fetched dogs: \(dogs)")
                self.dogs = dogs 
                completion(dogs, nil)
            }
        }
    }

}
