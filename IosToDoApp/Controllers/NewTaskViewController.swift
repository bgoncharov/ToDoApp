//
//  NewTaskViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/9/20.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConsraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    private let authManager = AuthManager()
    
    private var subscribers = Set<AnyCancellable>()
    var taskToEdit: Task?
    
    @Published private var taskString: String!
    @Published private var deadline: Date?
    
    weak var delegate: NewTaskVCDelegate?
    
    private lazy var calendar: CalendarView = {
        let view = CalendarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        observeForm()
        setupGesture()
        observeKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTextField.becomeFirstResponder()
    }
    
    private func observeForm() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
            .map({
                ($0.object as? UITextField)?.text
        }).sink { [unowned self] (text) in
            self.taskString = text
        }.store(in: &subscribers)
        
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)
        
        $deadline.sink { (date) in
            self.deadlineLabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)
    }
    
    private func setupViews() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottomConsraint.constant = -containerView.frame.height
        
        if let taskToEdit = self.taskToEdit {
            taskTextField.text = taskToEdit.title
            taskString = taskToEdit.title
            deadline = taskToEdit.deadline
            saveButton.setTitle("Update", for: .normal)
            guard let deadline = taskToEdit.deadline else { return }
            calendar.selectDate(date: deadline)
        }
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismisViewController))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showCalendar() {
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func dismissCalendarView(completion: () -> Void) {
        calendar.removeFromSuperview()
        completion()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification: notification)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [unowned self] in
            self.containerViewBottomConsraint.constant = keyboardHeight - (200 + 8)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewBottomConsraint.constant = -containerView.frame.height
    }
    
    // Keyboard heihgt
    
    private func getKeyboardHeight(notification: Notification) -> CGFloat {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0}
        return keyboardHeight
    }
    
    @objc private func dismisViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func calendarButtonTapped(_ sender: Any) {
        taskTextField.resignFirstResponder()
        showCalendar()
    }
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        
        guard let taskString = self.taskString, let uid = authManager.getUserID() else { return }
        var task = Task(title: taskString, deadline: deadline, uid: uid)
        
        if let id = taskToEdit?.id {
            task.id = id
        }
        
        if taskToEdit == nil {
            delegate?.didAddTask(task)
        } else {
            delegate?.didEditTask(task)
        }

    }
}

extension NewTaskViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if calendar.isDescendant(of: view) {
            if touch.view?.isDescendant(of: calendar) == false {
                dismissCalendarView { [unowned self] in
                    self.taskTextField.becomeFirstResponder()
                }
            }
            return false
        }
        return true
    }
    
}

extension NewTaskViewController: CalendarViewDelegate {
    
    func calendarViewDidSelectDate(date: Date) {
        dismissCalendarView {
            self.taskTextField.becomeFirstResponder()
            self.deadline = date
        }
    }
    
    func calendarViewDidTappedRemoveButton() {
        dismissCalendarView {
            self.taskTextField.becomeFirstResponder()
            self.deadline = nil
        }
    }
}
