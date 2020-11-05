//
//  RegisterViewController.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift
import UIKit

class RegisterViewController: UIViewController {

  private var viewModel: RegisterViewModelType = RegisterViewModel()
  
  @IBOutlet weak private var usernameTextField: UITextField!
  @IBOutlet weak private var passwordTextField: UITextField!
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.registered.subscribe { [weak self] (_) in
      self?.navigationController?.popViewController(animated: true)
    }.disposed(by: disposeBag)
    
  }
  
  
  // MARK: Privates
  
  @IBAction func registerAction(_ sender: AnyObject) {
    guard usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false else {
      return
    }
    
    viewModel.register(username: usernameTextField.text!, password: passwordTextField.text!)
  }
  
}
