//
//  DogListDetailPresenter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import Foundation

protocol DogListDetailPresenterProtocol {
    func viewWillAppear()
    func didSelectRow(at indexPath: IndexPath)
    func fetchDogs(page: Int)
    func loadMoreDogs()
}

class DogListDetailPresenter: DogListDetailPresenterProtocol {
    private let interactor:  DogListDetailInteractorProtocol
    private let router:  DogListDetailRouterProtocol
    private let viewController: DogListDetailViewControllerProtocol
    private var dogs: [Dog]?
    private var currentPage = 1
    var isFetchingMoreDogs = false
    var isLoading = false
    
    init(viewController: DogListDetailViewControllerProtocol,
         interactor: DogListDetailInteractorProtocol,
         router: DogListDetailRouterProtocol) {
        self.viewController = viewController
        self.interactor = interactor
        self.router = router
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.fetchDogs(page: self.currentPage)
        }
        
    }
    
    func viewWillAppear() {
        setDogs()
    }
    
    func setDogs() {
        // Sort dogs alphabetically based on name
        let filteredDogs = dogs?.filter { $0.breeds != nil || $0.breeds?.first?.name != nil || $0.breeds?.first?.origin != nil } ?? []
        let dogByName = filteredDogs.sorted { ($0.breeds?.first?.name ?? "") < ($1.breeds?.first?.name ?? "") }
        viewController.setDogs(dogs: dogByName)
    }

    func didSelectRow(at indexPath: IndexPath) {
        if let dog = dogs?[indexPath.row] {
            router.showDetail(dog: dog)
        } else {
            router.showAlert(with: "Error", message: "We could not find the dog details")
        }
    }
    
    func fetchDogs(page: Int) {
        isLoading = true
        viewController.showLoading(load: isLoading)
        interactor.fetchDogs(page: page, limit: 30) { dogs, error in
            if let error = error {
                print("Error: \(error)")
            } else if let dogs = dogs {
                print("Fetched dogs: \(dogs)")
                self.dogs = dogs
                self.setDogs()
                self.isLoading = false
                self.viewController.showLoading(load: self.isLoading)
            }
        }
    }
    
    func loadMoreDogs() {
        if !isFetchingMoreDogs {
            isFetchingMoreDogs = true
            currentPage += 1
            interactor.fetchDogs(page: currentPage, limit: 30, completion: { (newDogs, error) in
                if let newDogs = newDogs {
                    self.dogs?.append(contentsOf: newDogs)
                    self.setDogs()
                }
                self.isFetchingMoreDogs = false
            })
        }
    }
}
