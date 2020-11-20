//
//  Animatable.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/16/20.
//

import Foundation
import Loaf
import MBProgressHUD

protocol Animatable {
    
}

extension Animatable where Self: UIViewController {
    
    func showLoadingAnimation() {
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showToast(state: Loaf.State, text: String, location: Loaf.Location = .top, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            Loaf(text,
                 state: state,
                 location: location,
                 presentingDirection: .vertical,
                 dismissingDirection: .vertical,
                 sender: self).show(.custom(duration))
        }
    }
}
