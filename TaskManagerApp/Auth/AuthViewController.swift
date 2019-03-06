//
//  AuthViewController.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol AuthViewControllerDelegate:class {
    func didLogin()
}

class AuthViewController: UIViewController, NVActivityIndicatorViewable {
    
    let authViewModelController = AuthViewModel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var registrationSwitch: UISwitch!
    @IBOutlet weak var authActionSwitch: UISwitch!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var authButton: RoundedButton!
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addHideKeyboardAction()
    }
    
    @IBAction private func actionSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.titleLabel.text = "Sign up"
            self.authButton.setTitle("Register".uppercased(), for: .normal)
        } else {
            self.titleLabel.text = "Sign in"
            self.authButton.setTitle("Log in".uppercased(), for: .normal)
        }
    }
    
    @IBAction private func loginAction(_ sender: Any?) {
        startAnimating()
        do {
            try authViewModelController.authUser(email: emailTextField.text, password: passwordTextField.text, isRegister: self.authActionSwitch.isOn, successBlock: { [unowned self] in
                self.stopAnimating()
                self.delegate?.didLogin()
            }) { [unowned self] error in
                self.stopAnimating()
                self.handleError(error: error)
            }
        } catch {
            stopAnimating()
            self.handleError(error: error)
        }
    }
}

extension AuthViewController: UITextFieldDelegate {    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginAction(nil)
        }
        return true
    }
}

