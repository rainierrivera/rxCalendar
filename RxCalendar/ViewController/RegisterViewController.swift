//
//  RegisterViewController.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift
import UIKit

class RegisterViewController: UIViewController, BindableType {

  var viewModel: RegisterViewModelType!
  
  func bindViewModel() {
    
  }
  
  @IBOutlet weak private var usernameTextField: UITextField!
  @IBOutlet weak private var passwordTextField: UITextField!
  
  // MARK: Privates
  
  @IBAction func backAction(_ sender: AnyObject) {
    viewModel.pop()
  }
  
  @IBAction func registerAction(_ sender: AnyObject) {
    guard usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false else {
      return
    }
    
    viewModel.register(username: usernameTextField.text!, password: passwordTextField.text!)
  }
  
}
