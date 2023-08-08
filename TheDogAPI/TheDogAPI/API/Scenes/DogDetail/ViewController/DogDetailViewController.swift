//
//  DogDetailViewController.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

protocol DogDetailViewControllerProtocol {
    func setDog(dog: Dog)
}

class DogDetailViewController: UIViewController, DogDetailViewControllerProtocol {
    
    var presenter: DogDetailPresenterProtocol?
    
    // MARK: UI Elements
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let breedCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperamentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    func setDog(dog: Dog) {
        breedNameLabel.text = "Name: \(dog.breeds?.first?.name ?? "")"
        // TO DO: The Breed Category need to call another API
        breedCategoryLabel.text = "Category: \(dog.breeds?.first?.lifeSpan ?? "")"
        originLabel.text = "Origin: \(dog.breeds?.first?.origin ?? "")"
        temperamentLabel.text = "Temperament: \(dog.breeds?.first?.temperament ?? "")"
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(breedNameLabel)
        view.addSubview(breedCategoryLabel)
        view.addSubview(originLabel)
        view.addSubview(temperamentLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            breedNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            breedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            breedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            breedCategoryLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: 10),
            breedCategoryLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor),
            breedCategoryLabel.trailingAnchor.constraint(equalTo: breedNameLabel.trailingAnchor),
            
            originLabel.topAnchor.constraint(equalTo: breedCategoryLabel.bottomAnchor, constant: 10),
            originLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor),
            originLabel.trailingAnchor.constraint(equalTo: breedNameLabel.trailingAnchor),
            
            temperamentLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10),
            temperamentLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor),
            temperamentLabel.trailingAnchor.constraint(equalTo: breedNameLabel.trailingAnchor)
        ])
    }
}
