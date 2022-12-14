//
//  Injected.swift
//  DailyContainer
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation

@propertyWrapper
public class Injected<Value> {
    private let lazyValue: (() -> Value)
    private var storage: Value?
    
    public var wrappedValue: Value {
        storage ?? {
            let value: Value = lazyValue()
            storage = value
            return value
        }()
    }
    
    public init<K>(_ key: K.Type) where K: InjectionKey, Value == K.Value {
        lazyValue = { key.currentValue }
    }
}
