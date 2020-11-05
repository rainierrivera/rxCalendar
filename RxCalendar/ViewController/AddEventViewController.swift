//
//  AddEventViewController.swift
//  RxCalendar
//
//  Created by Collabera on 10/30/20.
//

import UIKit
import RxSwift
import EventKit

class AddEventViewController: UIViewController, BindableType {

  var viewModel: AddEventViewModelType!
  
  func bindViewModel() {
    startDate = viewModel.date
    datePicker.date = startDate
    datePicker.datePickerMode = .time
    datePicker.locale = .current
    
    endDatePicker.datePickerMode = .time
    endDatePicker.locale = .current
  
    dateStartTextField.inputView = datePicker
    dateEndTextField.inputView = endDatePicker
  
    datePicker.rx.date.subscribe { [weak self] (date) in
      guard let self = self, let date = date.element else { return }
      var min = date.hour
      
      if date.hour > 12 && !self.is24Hour() {
        min = date.hour - 12
      }
      
      self.dateStartTextField.text = "\(min):\(date.minute)"
      self.endDatePicker.minimumDate = date
      self.startDate = date
    }.disposed(by: disposeBag)
    
    
    endDatePicker.rx.date.subscribe { [weak self] (date) in
      guard let self = self, let date = date.element else { return }
      var min = date.hour
      
      if date.hour > 12 && !self.is24Hour() {
        min = date.hour - 12
      }
      self.endDate = date
      self.dateEndTextField.text = "\(min):\(date.minute)"
    }.disposed(by: disposeBag)
  }
  
  private let disposeBag = DisposeBag()
  
  @IBOutlet private weak var eventNameTextField: UITextField!
  @IBOutlet private weak var dateStartTextField: UITextField!
  @IBOutlet private weak var dateEndTextField: UITextField!
  
  private var datePicker = UIDatePicker()
  private var endDatePicker = UIDatePicker()
  private var startDate = Date()
  private var endDate = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "\(viewModel.date.monthName(.short)) \(viewModel.date.day) \(viewModel.date.year)"
    
  }
  
  
  // MARK: Privates
  
  private func is24Hour() -> Bool {
      let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
      return dateFormat.firstIndex(of: "a") == nil
  }
  
  @IBAction private func cancelAction(_ sender: AnyObject) {
    viewModel.cancel()
  }
  @IBAction private func saveAction(_ sender: AnyObject) {
    guard eventNameTextField.text?.isEmpty == false else {
      // TODO: Show Alert required fields
      return
    }
    let event = Event(name: eventNameTextField.text!, date: startDate, dateEnd: endDate, id: "")
  
    viewModel.addEvent(event: event)
    
  }
}
