//
//  DogListInteractor.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import Foundation

protocol DogListInteractorProtocol {
    func fetchDogs(completion: @escaping ([Dog]?, Error?) -> Void)
}

class DogListInteractor: DogListInteractorProtocol {
    private let repository: DogsRepositoryProtocol
    
    init(repository: DogsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDogs(completion: @escaping ([Dog]?, Error?) -> Void) {
        repository.fetchRandomDog(completion: completion)
    }
}
