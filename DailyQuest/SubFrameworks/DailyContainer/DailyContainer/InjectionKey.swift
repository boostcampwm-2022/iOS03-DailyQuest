//
//  InjectionKey.swift
//  DailyContainer
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation

public protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value { get }
}

public extension InjectionKey {
    static var currentValue: Value {
        return Container.shared.resolve(for: Self.self)
    }
}

public struct Module {
    let name: String
    let resolve: () -> Any
    
    public init<T: InjectionKey>(_ name: T.Type, _ resolve: @escaping () -> Any) {
        self.name = String(describing: name)
        self.resolve = resolve
    }
}
