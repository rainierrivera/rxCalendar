//
//  AddEventViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift

protocol AddEventViewModelType {
  var date: Date { get set }
  var navigationTitle: Observable<String> { get }
  
  func addEvent(event: Event)
  func cancel()
}

class AddEventViewModel: AddEventViewModelType {
  
  var date: Date
  var navigationTitle: Observable<String> {
    .just("\(date.monthName(.short)) \(date.day) \(date.year)")
  }
  private let sceneCoordinator: SceneCoordinatorType
  
  init(sceneCoordinator: SceneCoordinatorType, date: Date) {
    self.date = date
    self.sceneCoordinator = sceneCoordinator
  }
  
  func cancel() {
    sceneCoordinator.pop(animated: true)
  }
  
  func addEvent(event: Event) {
    EventKitCalendarManager.shared.addEventToCalendar(event: event) { [weak self] (result) in
      self?.sceneCoordinator.pop(animated: true)
    }
  }
}
