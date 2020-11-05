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

class CalendarViewController: UIViewController {

  @IBOutlet private weak var calendarView: FSCalendar!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var noEventLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    calendarView.dataSource = self
    calendarView.delegate = self
    
    SwiftDate.defaultRegion = .local
    
    navigationItem.title = "Event Calendar"

    tableView.tableFooterView = UIView()
    calendarViewModel
      .events
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "tableviewCell")) { row, event, cell in
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = "\(event.date.hour):\(event.date.minute) -  \(event.dateEnd.hour):\(event.dateEnd.minute)"
        cell.backgroundColor = event.date.isInPast ? .lightGray : .white
        cell.backgroundColor = Date().isInRange(date: event.date, and: event.dateEnd) ? .green :  cell.backgroundColor
    }.disposed(by: disposeBag)
    
    calendarViewModel.events
      .map { $0.count != 0 }
      .bind(to: noEventLabel.rx.isHidden)
      .disposed(by: disposeBag)
    calendarViewModel
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
      self.calendarViewModel.loadEvents(at: self.selectedDay)
    }.disposed(by: disposeBag)
    
    calendarViewModel.loadEvents(at: selectedDay)
  
  }
  
  // MARK: Privates
  
  private let calendarViewModel: CalendarViewModelType = CalendarViewModel()
  private let disposeBag = DisposeBag()
  private var selectedDay: Date = Date()
  private var addEventPublisher: PublishSubject<[Event]> = PublishSubject()
  
  @IBAction private func addEvent(_ sender: AnyObject) {
    showAddEvent(event: nil, date: selectedDay, events: addEventPublisher)
  }
  
  @IBAction private func signout(_ sender: AnyObject) {
    navigationController?.popViewController(animated: true)
  }
  
  private func showAddEvent(event: Event?, date: Date, events: PublishSubject<[Event]>) {
    let scene = Scene.addEvent(event: event, date: date, events: events).viewController()
    navigationController?.pushViewController(scene, animated: true)
  }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    selectedDay = date
    calendarViewModel.loadEvents(at: date)
  }
}
