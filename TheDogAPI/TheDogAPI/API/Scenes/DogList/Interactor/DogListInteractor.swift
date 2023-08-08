//
//  DogListInteractor.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import Foundation

protocol DogListInteractorProtocol {
    func fetchDogs(page: Int, limit: Int, completion: @escaping ([Dog]?, Error?) -> Void)
}

class DogListInteractor: DogListInteractorProtocol {
    private let repository: DogsRepositoryProtocol
    
    init(repository: DogsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDogs(page: Int, limit: Int, completion: @escaping ([Dog]?, Error?) -> Void) {
        repository.fetchRandomDog(page: page, limit: limit, completion: completion)
    }
}
