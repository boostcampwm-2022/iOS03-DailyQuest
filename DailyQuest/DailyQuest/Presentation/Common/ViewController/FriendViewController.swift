//
//  FriendViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/05.
//

import UIKit

import SnapKit

final class FriendViewController: UIViewController {
    
    // MARK: - Components
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var friendStatusView: FriendStatusView = {
        return FriendStatusView()
    }()
    
    /**
     Calendar view goes here.
     */
    
    /**
     Quest view goes here.
     */
    
    // MARK: - Life Cycle
    /**
     property method, `create` goes here.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(friendStatusView)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        friendStatusView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
}
