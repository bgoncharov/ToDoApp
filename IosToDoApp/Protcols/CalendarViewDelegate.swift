//
//  CalendarViewDelegate.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/17/20.
//

import Foundation

protocol CalendarViewDelegate: class {
    func calendarViewDidSelectDate(date: Date)
    func calendarViewDidTappedRemoveButton()
}
