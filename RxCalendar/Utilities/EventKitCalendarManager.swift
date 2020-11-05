//
//  EventKitCalendarManager.swift
//  RxCalendar
//
//  Created by Collabera on 11/4/20.
//

import Foundation
import EventKit
import EventKitUI
import SwiftDate
import RxSwift
import RxCocoa

enum EventKitResult {
  case success
  case error(Error?)
}

typealias EventKitResultResponse = (EventKitResult) -> ()

class EventKitCalendarManager: NSObject {
  static let shared = EventKitCalendarManager()
  
  private let eventStore: EKEventStore
  
  var shouldRefresh = PublishSubject<Bool>()
  
  override init() {
    eventStore = EKEventStore()
    shouldRefresh.onNext(false)
  }
  
  func addEventToCalendar(event: Event, completion : @escaping EventKitResultResponse) {
    let authStatus = authorizationStatus()
    switch authStatus {
    case .authorized:
        self.addEvent(event: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success)
            case .error(let error):
                completion(.error(error))
            }
        })
    case .notDetermined:
      requestAccess { (accessGranted, error) in
        if accessGranted {
          self.addEvent(event: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success)
            case .error(let error):
                completion(.error(error))
            }
          })
        } else {
          completion(.error(nil))
        }
      }
    default:
      completion(.error(nil))
    }
  }
  
  func presentEventCalendarDetailModal(event: Event, viewController: UIViewController) {
    let eventKitController = EKEventEditViewController()
    eventKitController.event = eventStore.event(withIdentifier: event.id)
    eventKitController.eventStore = eventStore
    eventKitController.editViewDelegate = self
    viewController.present(eventKitController, animated: true, completion: nil)
  }
  
  // Get all events
  func getEvents(with date: Date, completion: @escaping ([EKEvent]) -> ()){
    let authStatus = authorizationStatus()

    switch authStatus {
    case .authorized:
      completion(_getEvents(with: date))
    case .notDetermined:
      requestAccess { [weak self] (granted, error) in
        guard let self = self else { return }
        if granted {
          completion(self._getEvents(with: date))
        } else {
          completion([])
        }
      }
    default:
      completion([])
    }
  }
  
  // MARK: Privates
  
  private func _getEvents(with date: Date) -> [EKEvent] {
    var allEvents: [EKEvent] = []

    let calendars = self.eventStore.calendars(for: .event)
    for (_, calendar) in calendars.enumerated()  {
      let predicate = self.eventStore.predicateForEvents(withStart: date.convertToLocalMidnight(), end: date.endOfDay, calendars: [calendar])

      let matchingEvents = self.eventStore.events(matching: predicate)

      for event in matchingEvents {
        allEvents.append(event)
      }
    }
    return allEvents
  }
  
  private func addEvent(event: Event, completion : EventKitResultResponse) {
    let eventToAdd = generateEvent(event: event)
    if !eventAlreadyExists(event: eventToAdd) {
        do {
          try eventStore.save(eventToAdd, span: .thisEvent)
          completion(.success)
        } catch {
          completion(.error(error))
        }
    } else {
      completion(.error(nil))
    }
  }
  
  private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
    let predicate = eventStore.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
    let existingEvents = eventStore.events(matching: predicate)
    
    let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
        return eventToAdd.title == event.title
          && event.startDate == eventToAdd.startDate
          && event.endDate == eventToAdd.endDate
    }
    return eventAlreadyExists
  }
  
  private func generateEvent(event: Event) -> EKEvent {
    let newEvent = EKEvent(eventStore: eventStore)
    newEvent.calendar = eventStore.defaultCalendarForNewEvents
    newEvent.title = event.name
    newEvent.startDate = event.date
    newEvent.endDate = event.dateEnd

    return newEvent
  }
  
  private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
    eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
      completion(accessGranted, error)
    }
  }
  
  private func authorizationStatus() -> EKAuthorizationStatus {
    return EKEventStore.authorizationStatus(for: EKEntityType.event)
  }
}


extension EventKitCalendarManager: EKEventEditViewDelegate {
  func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
    shouldRefresh.onNext(true)
    controller.dismiss(animated: true, completion: nil)
  }
}
