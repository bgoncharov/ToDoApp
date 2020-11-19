//
//  NewTaskVCDelegate.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/12/20.
//

import Foundation

protocol NewTaskVCDelegate: class {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}
