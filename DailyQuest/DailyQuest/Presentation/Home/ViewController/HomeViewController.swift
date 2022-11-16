//
//  HomeViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class HomeViewController: UIViewController {
    
    
    // MARK: - Life Cycle
    // static func create(with viewModel: HomeViewModel)
    static func create() -> HomeViewController {
        return HomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
