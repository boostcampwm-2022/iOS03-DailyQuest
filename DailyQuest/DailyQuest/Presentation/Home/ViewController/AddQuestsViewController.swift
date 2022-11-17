//
//  AddQuestsViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import SnapKit

final class AddQuestsViewController: UIViewController {
    
    private lazy var indicateMessage: UILabel = {
        let indicateMessage = UILabel()
        indicateMessage.text = "여기서 새로운 퀘스트를 추가합니다."
        
        return indicateMessage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(indicateMessage)
        
        indicateMessage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
