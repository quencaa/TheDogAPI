//
//  DogListDataSource.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import UIKit

class DogListDataSource: NSObject, UICollectionViewDataSource {
    private var dogs = [Dog]()
    private var filteredDogs = [Dog]()
    private var hasSearchText: () -> Bool
    
    init(dogs: [Dog], hasSearchText: @escaping () -> Bool) {
        self.dogs = dogs
        self.hasSearchText = hasSearchText
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasSearchText() ? filteredDogs.count : dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BreedCollectionViewCell
        
        let dog = hasSearchText() ? filteredDogs[indexPath.row] : dogs[indexPath.row]
        cell.titleLabel.text = dog.breeds?.first?.name
        cell.imageView.setImageFromURL(dog.url ?? "")
        return cell
    }
    
    func updateDogs(_ dogs: [Dog]) {
        self.dogs = dogs
    }
    
    func updateFilteredBreeds(with searchText: String) {
        self.filteredDogs = dogs.filter { dog in
            let name = dog.breeds?.first?.name ?? ""
            return name.contains(searchText)
        }
    }
}
