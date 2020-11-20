//
//  LoginViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/18/20.
//

import UIKit

class LoginViewController: UIViewController, Animatable {
    
    weak var delegate: LoginVCDelegate?
    
    private let authManager = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let email = "boris@email.com"
    private let password = "1234567"
    
    @IBAction func loginWithBorisButton(_ semder: UIButton) {
        
        authManager.login(withEmail: email, password: password) { [weak self] (result) in
            switch result {
            
            case .success():
                self?.delegate?.didLogin()
            case .failure(let error):
                self?.showToast(state: .error, text: error.localizedDescription, duration: 3.0)
            }
        }
        
        
        
    }
}
