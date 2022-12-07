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
            make.centerY.equalToSuperview()
        }

        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(progressBar.snp.trailing)
            make.bottom.equalTo(progressBar.snp.top)
        }
    }

    private func bind() {
        profileButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
            self?.profileButtonDidClick.onNext(())
        })
            .disposed(by: disposableBag)
    }
}
