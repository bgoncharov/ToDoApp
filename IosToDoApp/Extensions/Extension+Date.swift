//
//  Extension+Date.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/17/20.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: self)
    }
}
