//
//  DogListRouter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import Foundation
import UIKit

protocol DogListRouterProtocol {
    func showDetail(dog: Dog)
    func showAlert(with title: String, message: String)
    var navigationController: UINavigationController { get }
}

class DogListRouter: DogListRouterProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetail(dog: Dog) {
        //let detailViewController = detailAssembler.resolveViewController(route: route)
        //navigationController.pushViewController(detailViewController, animated: true)
    }
    
    // Show alert in case of error
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
