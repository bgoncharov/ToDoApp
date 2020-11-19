//
//  LoginViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/18/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginWithBorisButton(_ semder: UIButton) {
        delegate?.didLogin()
    }
}
