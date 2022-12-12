//
//  LaunchViewController.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/12.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    var appCoordinator: AppCoordinator?
    let appDIContainer = AppDIContainer()
    
    let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "max.lottie")
        animationView.frame = CGRect(x:0,y:0,width: 300, height: 400)
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(animationView)
        animationView.center = view.center
        
        animationView.play{ (finish) in
            let tabbarController = UITabBarController()
            tabbarController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //self.present(tabbarController, animated: true, completion: nil)
            self.navigationController!.setViewControllers([tabbarController],
                       animated: true)
            self.appCoordinator = AppCoordinator(tabBarController: tabbarController,
                                                 appDIContainer: self.appDIContainer)
            self.appCoordinator?.start()
        }
    }
    
    deinit {
        print("deinit")
    }
    
}
