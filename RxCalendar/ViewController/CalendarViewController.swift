//
//  ViewController.swift
//  RxCalendar
//
//  Created by Collabera on 10/30/20.
//

import UIKit
import FSCalendar
import SwiftDate
import RxSwift
import RxCocoa
import EventKit

class CalendarViewController: UIViewController, BindableType {

  @IBOutlet private weak var calendarView: FSCalendar!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var noEventLabel: UILabel!
  
  var viewModel: CalendarViewModelType!
  
  func bindViewModel() {
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.loadEvents(at: selectedDay)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    calendarView.dataSource = self
    calendarView.delegate = self
    
    SwiftDate.defaultRegion = .local
    
    navigationItem.title = "Event Calendar"

    tableView.tableFooterView = UIView()
    viewModel
      .events
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "tableviewCell")) { row, event, cell in
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = "\(event.date.hour):\(event.date.minute) -  \(event.dateEnd.hour):\(event.dateEnd.minute)"
        cell.backgroundColor = event.date.isInPast ? .lightGray : .white
        cell.backgroundColor = Date().isInRange(date: event.date, and: event.dateEnd) ? .green :  cell.backgroundColor
    }.disposed(by: disposeBag)
    
    viewModel.events
      .map { $0.count != 0 }
      .bind(to: noEventLabel.rx.isHidden)
      .disposed(by: disposeBag)
    viewModel
      .events
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] (events) in
      self?.noEventLabel.isHidden = events.element?.count != 0
    }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Event.self)
      .do(onNext: { [weak self] (event) in
        if let tableViewIndexPath = self?.tableView.indexPathForSelectedRow {
          self?.tableView.deselectRow(at: tableViewIndexPath, animated: true)
        }
      })
    .subscribe { [unowned self] (event) in
      guard let event = event.element else { return }
      EventKitCalendarManager.shared.presentEventCalendarDetailModal(event: event, viewController: self)
    }.disposed(by: disposeBag)
    
    addEventPublisher.subscribe { [weak self] _ in
      guard let self = self else { return }
      self.viewModel.loadEvents(at: self.selectedDay)
    }.disposed(by: disposeBag)
    
    viewModel.loadEvents(at: selectedDay)
  
  }
  
  // MARK: Privates
  
  private let disposeBag = DisposeBag()
  private var selectedDay: Date = Date()
  private var addEventPublisher: PublishSubject<[Event]> = PublishSubject()
  
  @IBAction private func addEvent(_ sender: AnyObject) {
   showAddEvent(date: selectedDay)
  }
  
  @IBAction private func signout(_ sender: AnyObject) {
    viewModel.signout()
  }
  
  private func showAddEvent(date: Date) {
    viewModel.addEvent(date: date)
  }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    selectedDay = date
    viewModel.loadEvents(at: date)
  }
}
