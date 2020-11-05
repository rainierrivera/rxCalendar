//
//  LoginViewController.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

  private var viewModel: LoginViewModelType = LoginViewModel()
  private let disposeBag = DisposeBag()
  
  @IBOutlet private weak var usernameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var registerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Login"
    
    registerButton.isHidden = viewModel.isCurrentlyHaveUser
    
    viewModel.user
      .subscribe { [weak self] (_) in
        self?.usernameTextField.text = ""
        self?.passwordTextField.text = ""
        self?.navigationController?.pushViewController(Scene.calendar.viewController(), animated: true)
      }
      .disposed(by: disposeBag)
    
    viewModel.showError.subscribe {[weak self] (errorText) in
      self?.showAlert(withTitle: errorText)
    }.disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    registerButton.isHidden = viewModel.isCurrentlyHaveUser
  }
  
  // MARK: Privates
  
  @IBAction private func loginAction(_ sender: AnyObject) {
    guard usernameTextField.text?.isEmpty == false, passwordTextField.text?.isEmpty == false else {
      return
    }
    
    viewModel.login(username: usernameTextField.text!, password: passwordTextField.text!)
  }
  
  @IBAction private func registerAction(_ sender: AnyObject) {
    navigationController?.pushViewController(Scene.register.viewController(), animated: true)
  }
  
  private func showAlert(withTitle title: String) {
    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(action)
    
    present(alertController, animated: true, completion: nil)
  }
}
