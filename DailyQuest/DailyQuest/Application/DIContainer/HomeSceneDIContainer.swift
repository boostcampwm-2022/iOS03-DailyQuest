//
//  HomeSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class HomeSceneDIContainer {

    lazy var questsStorage: QuestsStorage = RealmQuestsStorage()
    lazy var userStorage: UserInfoStorage = RealmUserInfoStorage()
    lazy var networkService: NetworkService = FirebaseService.shared

    // MARK: - Repositories
    func makeQuestsRepository() -> QuestsRepository {
        return DefaultQuestsRepository(persistentStorage: questsStorage)
    }

    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(persistentStorage: userStorage, networkService: networkService)
    }

    // MARK: - Use Cases
    func makeQuestUseCase() -> QuestUseCase {
        return DefaultQuestUseCase(questsRepository: makeQuestsRepository())
    }

    func makeEnrollUseCase() -> EnrollUseCase {
        return DefaultEnrollUseCase(questsRepository: makeQuestsRepository())
    }

    func makeUesrUseCase() -> UserUseCase {
        return DefaultUserUseCase(userRepository: makeUserRepository())
    }

    // MARK: - View Models
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(questUseCase: makeQuestUseCase())
    }

    func makeEnrollViewModel() -> EnrollViewModel {
        return EnrollViewModel(enrollUseCase: makeEnrollUseCase())
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(userUseCase: makeUesrUseCase())
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
