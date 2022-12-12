//
//  ToggleItemViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import Foundation
import RxSwift

struct ToggleItemViewModel {
    let title: String
    let imageName: String
    let settingsUseCase: SettingsUseCase!
    
    struct Input {
        let toggleItemDidClicked: Observable<Bool>
    }
    
    struct Output {
        let toggleItemResult: Observable<Bool?>
    }
    
    func transform(input: Input) -> Output {
        let fetchAllow = settingsUseCase.isLoggedIn()
            .flatMap { _ in settingsUseCase.fetchAllow() }
            .asObservable()
        
        let changeAllow = input.toggleItemDidClicked
            .flatMap { isOn in
                settingsUseCase.updateAllow(allow: isOn).asObservable()
                    .map { result in result ? isOn : nil  }
            }
        
        let toggleItemResult = Observable.merge(fetchAllow, changeAllow)
        
        return Output(toggleItemResult: toggleItemResult)
    }
}
