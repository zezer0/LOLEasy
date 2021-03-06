//
//  Coordinator.swift
//  LOLEasy
//
//  Created by 재영신 on 2022/01/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
}
