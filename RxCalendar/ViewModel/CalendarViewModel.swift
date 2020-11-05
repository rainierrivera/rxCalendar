//
//  CalendarViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/2/20.
//

import RxSwift

protocol CalendarViewModelType {
  var events: PublishSubject<[Event]> { get set }
  
  func loadEvents(at selectedDate: Date)
}

class CalendarViewModel: CalendarViewModelType {
  
  var events: PublishSubject<[Event]> = PublishSubject()
  
  private let disposeBag = DisposeBag()
  private var selectedDate = Date()
  
  init() {
    EventKitCalendarManager.shared.shouldRefresh.subscribe { [weak self] (shouldRefresh) in
      guard let self = self, shouldRefresh.element == true else { return }
      self.loadEvents(at: self.selectedDate)
    }.disposed(by: disposeBag)
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