//
//  Container.swift
//  DailyContainer
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation

public class Container {
    public static var shared = Container()
    
    private var modules: [String: Module] = [:]
    
    public init() {}
    deinit { modules.removeAll() }
}

extension Container {
    func register(with module: Module) {
        modules[module.name] = module
    }
    
    func resolve<T>(for type: Any.Type?) -> T {
        let name = type.map { String(describing: $0) } ?? String(describing: T.self)
        
        guard let dependency: T = modules[name]?.resolve() as? T else {
            fatalError("dependency \(T.self) not resolved.")
        }
        
        return dependency
    }
}

public extension Container {
    func register(@ModuleBuilder _ modules: () -> [Module]) {
        modules().forEach { register(with: $0) }
    }
    
    func register(@ModuleBuilder _ module: () -> Module) {
        register(with: module())
    }
    
    @resultBuilder
    struct ModuleBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] {
            modules
        }
        
        public static func buildBlock(_ module: Module) -> Module {
            module
        }
    }
}

