//
//  CalendarViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/2/20.
//

import RxSwift

protocol CalendarViewModelType {
  var events: PublishSubject<[Event]> { get set }
  var navigationTitle: Observable<String> { get }
  func loadEvents(at selectedDate: Date)
  func addEvent(date: Date)
  func signout()
}

class CalendarViewModel: CalendarViewModelType {
  
  var events: PublishSubject<[Event]> = PublishSubject()
  var navigationTitle: Observable<String> {
    .just("Event Calendar")
  }
  
  private let disposeBag = DisposeBag()
  private var selectedDate = Date()
  
  private let sceneCoordinator: SceneCoordinatorType
  
  init(sceneCoordinator: SceneCoordinatorType) {
    self.sceneCoordinator = sceneCoordinator
  
    EventKitCalendarManager.shared.shouldRefresh.subscribe { [weak self] (shouldRefresh) in
      guard let self = self, shouldRefresh.element == true else { return }
      self.loadEvents(at: self.selectedDate)
    }.disposed(by: disposeBag)
  }
  
  func signout() {
    sceneCoordinator.pop(animated: true)
  }
  
  func addEvent(date: Date) {
    let viewModel = AddEventViewModel(sceneCoordinator: sceneCoordinator, date: date)
    sceneCoordinator.transition(to: Scene.addEvent(viewModel: viewModel), type: .push(animated: true))
  }
  
  func loadEvents(at selectedDate: Date = Date()) {
    self.selectedDate = selectedDate
    EventKitCalendarManager.shared.getEvents(with: selectedDate) { [weak self] calendarEvents in
      guard let self = self else { return }
      var _events = [Event]()
      calendarEvents.forEach { calendarEvent in
        let event = Event(name: calendarEvent.title, date: calendarEvent.startDate, dateEnd: calendarEvent.endDate, id: calendarEvent.eventIdentifier)
        _events.append(event)
      }
      self.events.onNext(_events)
    }
  }
}
