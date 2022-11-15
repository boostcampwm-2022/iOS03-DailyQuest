//
//  QuestCell.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/14.
//

import UIKit
import SnapKit

class BrowseCell: UITableViewCell {
    
    static let reuseIdentifier = "QuestCell"
    
    /*
     override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)
     
     // Configure the view for the selected state
     }
     */
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = .lightGray
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.layer.cornerRadius = 15
        return stackView
    }()
    
    private lazy var questStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .lightGray
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 15
        return stackView
    }()
    
    private lazy var userImageView: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(systemName: "heart.fill")
        userImage.clipsToBounds = true
        userImage.backgroundColor = .white
        userImage.layer.masksToBounds = true
        return userImage
    }()
    
    private lazy var userQuestLabel: UILabel = {
        let userQuest = UILabel()
        userQuest.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        userQuest.font = UIFont.boldSystemFont(ofSize: 16)
        userQuest.text = " "
        return userQuest
    }()
    
    
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    private func configureUI() {
        userStackView.addArrangedSubview(userImageView)
        userStackView.addArrangedSubview(userQuestLabel)
        questStackView.addArrangedSubview(userStackView)
        
        addSubview(questStackView)
        
        userStackView.snp.makeConstraints { make in
            make.width.equalTo(questStackView).inset(10)
            make.height.equalTo(80)
        }
        
        questStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        userImageView.snp.makeConstraints { make in
            make.height.equalTo(userStackView.snp.height).offset(-50)
            make.width.equalTo(userImageView.snp.height)
        }
        
        for subview in questStackView.subviews {
            subview.snp.makeConstraints { (make) in
                make.height.equalTo(subview.frame.height)
                make.width.equalTo(questStackView.snp.width)
            }
        }
    }
    
    func setup(user: User, quest: [Quest]) {
        userQuestLabel.text = user.nickName + "님의 Today Quest"
        //guard let image = UIImage(data: user.profile) else { return }
        //userImageView.image = image
        
        let height:Double = 100.0 * (1.0 + Double(quest.count))
        
        print(height)
        
        questStackView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        for q in quest {
            var questView = QuestView()
            questView.setUp(with: q)
            questStackView.addArrangedSubview(questView)
        }
        
        
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct BrowseCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = BrowseCell(frame: .zero)
            cell.setup(user: User(uuid: UUID(), nickName: "맥스", profile: Data(), backgroundImage: Data(), description: ""), quest: [Quest(title: "물 마시기", startDay: Date(), endDay: Date(), repeat: 0, currentCount: 1, totalCount: 5), Quest(title: "물 마시기", startDay: Date(), endDay: Date(), repeat: 0, currentCount: 1, totalCount: 5), Quest(title: "물 마시기", startDay: Date(), endDay: Date(), repeat: 0, currentCount: 1, totalCount: 5)])
            return cell
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
