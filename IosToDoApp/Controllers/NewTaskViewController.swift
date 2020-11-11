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
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String!
    
    private let databaseManager = DatabaseManager()
    
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
    }
    
    private func setupViews() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottomConsraint.constant = -containerView.frame.height
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismisViewController))
        view.addGestureRecognizer(gesture)
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    }
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        
        guard let taskString = self.taskString else { return }
        let task = Task(title: taskString)
        
        databaseManager.addTask(task) { (result) in
            switch result {
            
            case .success():
                print("good")
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
