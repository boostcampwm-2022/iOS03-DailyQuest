//
//  QuestCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

import SnapKit

final class QuestCell: UITableViewCell {
    private lazy var progressView: CustomProgressBar = {
        let progressView = CustomProgressBar()
        progressView.trackTintColor = .maxLightYellow
        progressView.progressTintColor = .maxYellow
        progressView.progress = 0.2
        
        return progressView
    }()
    
    private lazy var questLabel: UILabel = {
        let questLabel = UILabel()
        questLabel.text = "0"
        questLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return questLabel
    }()
    
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    private func configureUI() {
        addSubview(progressView)
        addSubview(questLabel)
        addSubview(countLabel)
        
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        questLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView).inset(30)
            make.trailing.equalTo(progressView).inset(10)
        }
    }
    
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
            let quest = Quest(title: "my quest", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 2, totalCount: 5)
            
            cell.setup(with: quest)
            return cell
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
#endif

