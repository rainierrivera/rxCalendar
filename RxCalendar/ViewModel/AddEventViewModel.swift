//
//  AddEventViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift

protocol AddEventViewModelType {
  var date: Date { get set }
  var event: Event? { get set }
  var events: PublishSubject<[Event]> { get set }
  
  func addedEvent()
}

class AddEventViewModel: AddEventViewModelType {
  
  var date: Date
  var event: Event?
  var events: PublishSubject<[Event]> = PublishSubject()
  
  init(event: Event?, date: Date, events: PublishSubject<[Event]>) {
    self.date = date
    self.events = events
    self.event = event
  }
  
  func addedEvent() {
    EventKitCalendarManager.shared.getEvents(with: date) { [weak self] calendarEvents in
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
