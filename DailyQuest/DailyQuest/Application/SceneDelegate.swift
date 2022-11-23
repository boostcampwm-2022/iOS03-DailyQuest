//
//  SceneDelegate.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/11.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let appDIContainer = AppDIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        AppAppearance.setupAppearance()
        
        let tabbarController = UITabBarController()
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
        
        //_ = FirebaseService.shared.update(userCase: .currentUser, access: .quests, dto: QuestDTO(uuid: UUID(uuidString: "16AF9B21-4C85-4EF9-9DF5-B1A3385C9D56") ?? UUID(), title: "바꾸기", currentCount: 0, totalCount: 0, groupUid: UUID(uuidString: "98AC0127-5CAF-4DC7-9365-9E5F819053BE") ?? UUID()))
        _ = FirebaseService.shared.create(userCase: .currentUser, access: .quests, dto: QuestDTO(uuid: UUID(), title: "", currentCount: 0, totalCount: 0, groupUid: UUID()))
        
        self.appCoordinator = AppCoordinator(tabBarController: tabbarController,
                                             appDIContainer: appDIContainer)
        self.appCoordinator?.start()
        
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

