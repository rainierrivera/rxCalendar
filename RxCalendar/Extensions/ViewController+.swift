//
//  ViewController+.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import Foundation

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
