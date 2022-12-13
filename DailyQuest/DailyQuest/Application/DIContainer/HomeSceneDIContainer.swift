//
//  HomeSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit
import DailyContainer

final class HomeSceneDIContainer {

    init() {
        registerUseCase()
    }

    // MARK: - View Models
    func makeHomeViewModel() -> HomeViewModel {
        @Injected(QuestUseCaseKey.self)
        var questUseCase: QuestUseCase
        
        @Injected(UserUseCaseKey.self)
        var userUseCase: UserUseCase
        
        @Injected(CalendarUseCaseKey.self)
        var calendarUseCase: CalendarUseCase
        
        return HomeViewModel(userUseCase: userUseCase,
                             questUseCase: questUseCase,
                             calendarUseCase: calendarUseCase)
    }

    func makeEnrollViewModel() -> EnrollViewModel {
        @Injected(EnrollUseCaseKey.self)
        var enrollUseCase: EnrollUseCase
        
        return EnrollViewModel(enrollUseCase: enrollUseCase)
    }

    func makeProfileViewModel() -> ProfileViewModel {
        @Injected(UserUseCaseKey.self)
        var userUseCase: UserUseCase
        
        return ProfileViewModel(userUseCase: userUseCase)
    }

    // MARK: - View Controller
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController.create(with: makeHomeViewModel())
    }

    func makeEnrollViewController() -> EnrollViewController {
        return EnrollViewController.create(with: makeEnrollViewModel())
    }

    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController.create(with: makeProfileViewModel())
    }

    // MARK: - Flow
    func makeHomeCoordinator(navigationController: UINavigationController,
                             homeSceneDIContainer: HomeSceneDIContainer) -> HomeCoordinator {
        return DefaultHomeCoordinator(navigationController: navigationController,
                                      homeSceneDIContainer: homeSceneDIContainer)
    }
}

private extension HomeSceneDIContainer {
    func registerUseCase() {
        Container.shared.register {
            Module(QuestUseCaseKey.self) {
                @Injected(QuestRepositoryKey.self)
                var questRepository: QuestsRepository
                
                return DefaultQuestUseCase(questsRepository: questRepository)
            }
            
            Module(EnrollUseCaseKey.self) {
                @Injected(QuestRepositoryKey.self)
                var questRepository: QuestsRepository
                
                return DefaultEnrollUseCase(questsRepository: questRepository)
            }
            
            Module(UserUseCaseKey.self) {
                @Injected(UserRepositoryKey.self)
                var userRepository: UserRepository
                
                return DefaultUserUseCase(userRepository: userRepository)
            }
            
            Module(CalendarUseCaseKey.self) {
                @Injected(QuestRepositoryKey.self)
                var questRepository: QuestsRepository
                
                return HomeCalendarUseCase(questsRepository: questRepository)
            }
        }
    }
}
