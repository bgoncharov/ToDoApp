//
//  TaskVCDelegate.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/12/20.
//

import Foundation

protocol TaskVCDelegate: class {
    func didAddTask(_ task: Task)
}
