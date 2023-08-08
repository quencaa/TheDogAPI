//
//  DogListDetailInteractor.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import Foundation

protocol DogListDetailInteractorProtocol {
    func fetchDogs(page: Int, limit: Int, completion: @escaping ([Dog]?, Error?) -> Void)
}

class DogListDetailInteractor: DogListDetailInteractorProtocol {
    private let repository: DogsRepositoryProtocol
    
    init(repository: DogsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDogs(page: Int, limit: Int, completion: @escaping ([Dog]?, Error?) -> Void) {
        repository.fetchRandomDog(page: page, limit: limit, completion: completion)
    }
}
