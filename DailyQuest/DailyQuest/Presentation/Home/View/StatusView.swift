//
//  StatusView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/22.
//

import UIKit

import SnapKit

final class StatusView: UIView {
    
    // MARK: - Components
    private lazy var iconContainer: UIImageView = {
        let iconContainer = UIImageView()
        iconContainer.image = UIImage(named: "StatusMax")
        
        return iconContainer
    }()
    
    private lazy var messageBubble: MessageBubbleLabel = {
        return MessageBubbleLabel()
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "0 / 0"
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        statusLabel.textColor = .maxViolet
        
        return statusLabel
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .maxLightGrey
        progressBar.progressTintColor = .maxGreen
        progressBar.progress = 0.2
        
        return progressBar
    }()
    
    private lazy var profileButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "person.crop.circle",
                               withConfiguration: largeConfig)
        config.baseForegroundColor = .maxLightGrey
        
        return UIButton(configuration: config)
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     UI의 constraints를 설정하기 위한 메서드입니다.
     constraints를 설정하기 전에, 해당 뷰를 먼저 add해야함을 유념하세요.
     */
    private func configureUI() {
        addSubview(iconContainer)
        iconContainer.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(iconContainer.snp.height)
            make.leading.equalToSuperview()
        }
        
        addSubview(messageBubble)
        messageBubble.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing)
            make.top.equalToSuperview().inset(10)
        }
        
        addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(5)
        }
        
        addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(profileButton.snp.height)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(progressBar.snp.trailing)
            make.bottom.equalTo(progressBar.snp.top)
        }
    }
    
    // Setup method goes here.
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct StatusViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = StatusView(frame: .zero)
            
            return view
        }
        .previewLayout(.fixed(width: 500, height: 100))
    }
}
#endif
