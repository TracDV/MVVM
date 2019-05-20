//
//  LoginViewController.swift
//  LoginGitHub
//
//  Created by Dinh Trac on 5/18/19.
//  Copyright © 2019 Dinh Trac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
   
    @IBOutlet weak var validUserNameText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validPasswordText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLogin: UILabel!
    
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        viewModel = LoginViewModel()
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.red
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.black.cgColor
        bindUI()
    }

    @IBAction func didTapLogin(_ sender: Any) {
       _ = viewModel.userLogin.asObservable().subscribe { user in
            guard let user = user.element else {
                self.errorLogin.text = "User name or password is wrong"
                return
            }
            //Transit to Home Controller
        let homeController = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeController, animated: true)
//            self.errorLogin.text = user?.name
        }
    }
    
    func bindUI() {
        _ = userNameTextField.rx.text.map { $0  ?? "" }.bind(to: self.viewModel.userName)
        _ = passwordTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.password)
        _ = viewModel.isValid.subscribe({[weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.loginButton.isEnabled = isValid
            strongSelf.loginButton.backgroundColor = isValid ? UIColor.green : UIColor.red
        })
    }

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.userNameTextField:
            //Handle for User name
            self.viewModel.isValidUserName.subscribe({[weak self] isValid in
                self?.validUserNameText.text = isValid.element! ? "Valid User Name" : "Invalid User Name"
                self?.validUserNameText.textColor = isValid.element! ? UIColor.black : UIColor.red
            }).disposed(by: disposeBag)
            break
        case self.passwordTextField:
            //Handle for password
            self.viewModel.isValidPassword.subscribe({[weak self] isValid in
                self?.validPasswordText.text = isValid.element! ? "Valid Password" : "Invalid Password"
                self?.validPasswordText.textColor = isValid.element! ? UIColor.black : UIColor.red
            }).disposed(by: disposeBag)
            break
        default:
            break
        }
    }
}
