//
//  Observable.swift
//  Qliq
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol ObservableProtocol {
    associatedtype T
    var value: T { get set }
    func subscribe(_ observer: AnyObject, fireNow: Bool, _ onChange: @escaping (_ newValue: T) -> ())
    func unsubscribe(_ observer: AnyObject)
}

public final class Observable<T>: ObservableProtocol {

    typealias ObserverBlock = (_ newValue: T) -> ()
    typealias ObserversEntry = (observer: AnyObject, block: ObserverBlock)

    private var observers: [ObserversEntry]
    
    init(value: T) {
        self.value = value
        observers = []
    }

    var value: T {
        didSet {
            notify()
        }
    }

    func subscribe(_ observer: AnyObject, fireNow: Bool = true, _ onChange: @escaping ObserverBlock) {
        let entry: ObserversEntry = (observer: observer, block: onChange)
        observers.append(entry)
        
        if fireNow {
            onChange(value)
        }
    }

    func unsubscribe(_ observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    func notify() {
        observers.forEach { (entry: ObserversEntry) in
            let (_, block) = entry
            block(value)
        }
    }
}
