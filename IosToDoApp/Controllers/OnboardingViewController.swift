//
//  OnboardingViewController.swift
//  IosToDoApp
//
//  Created by Boris Goncharov on 11/18/20.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginScreen", let destination = segue.destination as? LoginViewController {
            destination.delegate = self
        }
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showLoginScreen", sender: nil)
    }
}

extension OnboardingViewController: LoginVCDelegate {
    
    func didLogin() {
        presentedViewController?.dismiss(animated: true, completion: {
            print("we should login")
        })
    }
}
