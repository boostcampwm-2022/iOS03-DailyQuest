//
//  QuestView.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/14.
//

import UIKit
import SnapKit

class QuestView: UIView {
    
    // assets 에 한번에 나중에 추가하려고 일단은 임의로 색상 넣음
    private var backgroundLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 80)
        label.backgroundColor = .yellow
        label.layer.masksToBounds = true
        return label
    }()
    
    private var progressLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        label.backgroundColor = .systemYellow
        label.layer.masksToBounds = true
        return label
    }()
    
    private var questLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private var countLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLabel.layer.cornerRadius = backgroundLabel.bounds.size.height / 7
        progressLabel.layer.cornerRadius = progressLabel.bounds.size.height / 8
    }
    
    private func configureUI() {
        self.addSubview(backgroundLabel)
        self.addSubview(progressLabel)
        self.addSubview(questLabel)
        self.addSubview(countLabel)
        
        backgroundLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(300)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.equalTo(backgroundLabel)
        }
        
        questLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel).inset(30)
            make.left.equalTo(backgroundLabel).inset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel).inset(30)
            make.right.equalTo(backgroundLabel).inset(10)
        }
        
    }
    
    func setUp(with quest: Quest) {
        let progressWidth = 300.0 * (Double(quest.currentCount)/Double(quest.totalCount))
        
        questLabel.text = quest.title
        countLabel.text = String(quest.currentCount) + " / " + String(quest.totalCount)
        progressLabel.snp.makeConstraints { make in
            make.width.equalTo(progressWidth)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct QuestionViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = QuestView(frame: .zero)
            view.setUp(with: Quest(title: "물 마시기", startDay: Date(), endDay: Date(), repeat: 0, currentCount: 2, totalCount: 5))
            return view
        }.previewLayout((.fixed(width: 300, height: 80)))
    }
}
#endif

