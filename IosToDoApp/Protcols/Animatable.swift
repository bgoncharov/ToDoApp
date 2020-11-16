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
    func showInfoToast(text: String, location: Loaf.Location, duration: TimeInterval) {
        DispatchQueue.main.async {
            Loaf(text, state: .info,
                 location: location,
                 presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.custom(duration))
        }
    }
}
