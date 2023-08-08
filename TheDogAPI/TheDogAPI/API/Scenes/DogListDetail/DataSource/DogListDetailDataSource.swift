//
//  DogListDetailDataSource.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import Foundation
import UIKit

class DogListDetailDataSource: NSObject, UITableViewDataSource {
    private var dogs = [Dog]()
    private var filteredDogs = [Dog]()
    private var hasSearchText: () -> Bool
    
    init(dogs: [Dog], hasSearchText: @escaping () -> Bool) {
        self.dogs = dogs
        self.hasSearchText = hasSearchText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasSearchText() ? filteredDogs.count : dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as! BreedTableViewCell
        let dog = hasSearchText() ? filteredDogs[indexPath.row] : dogs[indexPath.row]
        
        cell.breedNameLabel.text = dog.breeds?.first?.name
        //cell.breedGroupLabel.text = dog.breeds?.first?.group
        cell.originLabel.text = dog.breeds?.first?.origin
        
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
