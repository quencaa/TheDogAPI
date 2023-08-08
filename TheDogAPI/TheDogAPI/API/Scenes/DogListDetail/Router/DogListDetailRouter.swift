//
//  DogListDetailRouter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

protocol DogListDetailRouterProtocol {
    func showDetail(dog: Dog)
    func showAlert(with title: String, message: String)
    var navigationController: UINavigationController { get }
}

class DogListDetailRouter: DogListDetailRouterProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetail(dog: Dog) {
        let detailViewController = DogDetailAssembler.resolveViewController(with: dog)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        self.navigationController.present(navigationController, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
