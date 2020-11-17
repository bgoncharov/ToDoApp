//
//  CalendarView.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/16/20.
//

import UIKit
import FSCalendar

class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate?
    
    private lazy var calendar: FSCalendar = {
       let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        return calendar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Selected date"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel, calendar, removeButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // Hide removeButton if date not selected
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if calendar.selectedDate == nil {
            removeButton.removeFromSuperview()
        } else if removeButton.isDescendant(of: stack) == false {
            stack.addArrangedSubview(removeButton)
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            calendar.heightAnchor.constraint(equalToConstant: 240),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        if let selectedDate = calendar.selectedDate {
            calendar.deselect(selectedDate)
            delegate?.calendarViewDidTappedRemoveButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarView: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.calendarViewDidSelectDate(date: date)
    }
    
}
