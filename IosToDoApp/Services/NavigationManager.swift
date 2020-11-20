//
//  NavigationManager.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/19/20.
//

import UIKit

class NavigationManager {
    
    static let shared = NavigationManager()
    
    private init() {}
    
    enum Scene {
        case onboarding
        case tasks
    }
    
    
    func show(scene: Scene) {
        
        switch scene {
        
        case .onboarding: break
        case .tasks:
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskNavigationViewController")
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window else { return }
            
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
        
    }
    
}
