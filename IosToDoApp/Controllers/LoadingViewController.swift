//
//  LoadingViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/19/20.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showInitialScreen()
    }
    
    func showInitialScreen() {
        if authManager.isUserLogedIn() {
            navigationManager.show(scene: .tasks)
        } else {
            navigationManager.show(scene: .onboarding)
        }
    }
}
