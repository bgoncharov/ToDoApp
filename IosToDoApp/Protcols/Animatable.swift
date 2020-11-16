//
//  Animatable.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/16/20.
//

import Foundation
import Loaf

protocol Animatable {
    
}

extension Animatable where Self: UIViewController {
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
