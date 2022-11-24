//
//  NavigateCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

final class NavigateCell: UITableViewCell {
    static let reuseIdentifier = "NavigateCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(icon)
        addSubview(title)
        
        icon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(padding)
        }
        
        title.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(padding)
            make.leading.equalTo(icon.snp.trailing).offset(10)
        }
    }
    
    func setup(with viewModel: NavigateItemViewModel) {
        icon.image = UIImage(systemName: viewModel.imageName)
        title.text = viewModel.title
    }
}
