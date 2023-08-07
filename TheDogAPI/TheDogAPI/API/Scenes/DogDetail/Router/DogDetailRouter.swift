//
//  DogDetailRouter.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import Foundation
import Foundation
import UIKit

protocol DogDetailRouterProtocol {
    var navigationController: UINavigationController { get }
}

class DogDetailRouter: DogDetailRouterProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
