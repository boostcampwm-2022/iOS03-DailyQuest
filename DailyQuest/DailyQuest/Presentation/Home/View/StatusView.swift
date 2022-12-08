//
//  StatusView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/22.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class StatusView: UIView {
    private var disposableBag = DisposeBag()
    var profileButtonDidClick = PublishSubject<Void>()
    var userDataFetched = PublishSubject<User>()
    
    // MARK: - Components
    private lazy var iconContainer: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "StatusMax")
        let iconContainer = UIButton(configuration: config)
        iconContainer.imageView?.contentMode = .scaleToFill
        return iconContainer
    }()
    
    private lazy var messageBubble: MessageBubbleLabel = {
        return MessageBubbleLabel(text: getRandomMessage())
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
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .maxLightGrey
        config.image = UIImage(systemName: "person.crop.circle")
        
        let button = UIButton(configuration: config)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(iconContainer)
        iconContainer.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(iconContainer.snp.height)
            make.top.leading.bottom.equalToSuperview()
        }
        
        iconContainer.imageView?.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.leading.equalToSuperview()
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
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(75)
            make.width.equalTo(75)
        }
        
        profileButton.imageView?.snp.makeConstraints({ make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview()
        })
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(progressBar.snp.trailing)
            make.bottom.equalTo(progressBar.snp.top)
        }
    }
    
    private func bind() {
        iconContainer.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.messageBubble.setText(text: self.getRandomMessage())
            })
            .disposed(by: disposableBag)
        
        profileButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.profileButtonDidClick.onNext(())
            })
            .disposed(by: disposableBag)
        
        userDataFetched
            .asDriver(onErrorJustReturn: User())
            .drive(onNext: { [weak self] user in
                guard let self = self else { return }
                self.profileButton.setImage(with: user.profileURL)
            }).disposed(by: disposableBag)
    }
}

