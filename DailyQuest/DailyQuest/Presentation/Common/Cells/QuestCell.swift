//
//  QuestCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

import SnapKit

final class QuestCell: UITableViewCell {
    /// dequeuResusable을 위한 아이덴티파이어입니다.
    static let reuseIdentifier = "QuestCell"
    
    // MARK: - Components
    /**
     프로그래스 바 입니다. 기존의 `UIProgressBar`를 상속받는
     `CustomProgressBar`를 타입으로 합니다.
     이 클래스는 코너의 radius 값을 주기 위해 만들어졌습니다.
     */
    private lazy var progressView: CustomProgressBar = {
        let progressView = CustomProgressBar()
        progressView.trackTintColor = .maxLightYellow
        progressView.progressTintColor = .maxYellow
        progressView.progress = 0.2
        
        return progressView
    }()
    
    /**
     좌측에 quest의 제목이 들어갈 레이블입니다.
     */
    private lazy var questLabel: UILabel = {
        let questLabel = UILabel()
        questLabel.text = "0"
        questLabel.font = UIFont.boldSystemFont(ofSize: 16)
        questLabel.textColor = .maxViolet
        
        return questLabel
    }()
    
    /**
     우측에 현재 달성량과 목표량이 들어갈 레이블입니다.
     */
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.font = UIFont.boldSystemFont(ofSize: 16)
        countLabel.textColor = .maxViolet
        
        return countLabel
    }()
    
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        addSubview(progressView)
        addSubview(questLabel)
        addSubview(countLabel)
        
        backgroundColor = UIColor(white: 1, alpha: 0)
        
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        questLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(progressView).inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    /**
     인자로 받은 Entity Quest타입을 통해 그 정보를 기반으로 cell에 아이템을 넣습니다.
     
     애니메이션 효과가 필요없다고 판단하여, `setProgress(_:animated)`에서 두번째 인자를
     `false`로 설정하였습니다.
     
     - Parameters:
        - quest: Quest타입의 엔티티입니다.
     */
    func setup(with quest: Quest) {
        let value = Float(quest.currentCount) / Float(quest.totalCount)
        questLabel.text = "\(quest.title)"
        countLabel.text = "\(quest.currentCount) / \(quest.totalCount)"

        progressView.setProgress(value, animated: false)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct QuestCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = QuestCell(frame: .zero)
            let quest = Quest(groupId: UUID(), uuid: UUID(),date: Date(), title: "my quest", currentCount: 2, totalCount: 5)
            
            cell.setup(with: quest)
            return cell
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
#endif

