//
//  LoginViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/18/20.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Animatable {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @Published var errorString: String?
    @Published var isLoginSuccessfull = false
    
    weak var delegate: LoginVCDelegate?
    
    private var subscribers = Set<AnyCancellable>()
    
    private let authManager = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    private func observeForm() {
        $errorString.sink { [unowned self] (errorMessage) in
            self.errorLabel.text = errorMessage
        }.store(in: &subscribers)
        
        $isLoginSuccessfull.sink { [unowned self] (isLogin) in
            if isLogin {
                self.delegate?.didLogin()
            }
        }.store(in: &subscribers)
    }
    
    @IBAction func loginButton(_ semder: UIButton) {
        
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            errorString = "Incomplete form"
            return
        }
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.login(withEmail: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
            
            case .success():
                self?.isLoginSuccessfull = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
    }
    
    @IBAction func signUpButton(_ semder: UIButton) {
        
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            errorString = "Incomplete form"
            return
        }
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.signUp(email: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
            
            case .success():
                self?.isLoginSuccessfull = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
    }
}
