//
//  ToggleCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class ToggleCell: UITableViewCell {
    static let reuseIdentifier = "ToggleCell"
    private var viewModel: ToggleItemViewModel!
    
    var toggleItemDidClicked = PublishSubject<Bool>()
    private var disposableBag = DisposeBag()
    
    private let padding = 20
    
    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "pencil")
        icon.tintColor = .black
        
        return icon
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.text = "some setting title"
        title.textColor = .black
        
        return title
    }()
    
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(toggle)
        
        icon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(padding)
        }
        
        title.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(padding)
            make.leading.equalTo(icon.snp.trailing).offset(10)
        }
        
        toggle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(padding)
        }
    }
    
    func setup(with viewModel: ToggleItemViewModel) {
        icon.image = UIImage(systemName: viewModel.imageName)
        title.text = viewModel.title
        self.viewModel = viewModel
        bind()
    }
    
    func bind() {
        toggle.rx.tapGesture()
            .when(.ended)
            .do(onNext: { _ in
                print(self.toggle.isOn)
            })
            .bind(onNext: {_ in
                self.toggleItemDidClicked.onNext(!self.toggle.isOn)
            })
            .disposed(by: disposableBag)
        
        let output = viewModel.transform(input: ToggleItemViewModel.Input(
            toggleItemDidClicked: toggleItemDidClicked
        ))
        
        output.toggleItemResult
            .subscribe(onNext: { isOn in
                guard let isOn = isOn else {
                    self.toggle.isOn = false
                    self.toggle.isEnabled = false
                    return
                }
                
                if !self.toggle.isEnabled {
                    self.toggle.isEnabled = true
                }
                DispatchQueue.main.async {
                    self.toggle.isOn = isOn
                }
            })
            .disposed(by: disposableBag)
    }
}
