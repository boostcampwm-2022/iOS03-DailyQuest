//
//  CircleCheckView.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/14.
//

import UIKit
import SnapKit

class CircleCheckView: UIView {
    
    // MARK: - Sub Views
    
    private lazy var circleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.973, green: 0.953, blue: 0.831, alpha: 1)
        return view
    }()
    
    private lazy var displayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    // MARK: - Configuration View
    
    private func addSubviews() {
        self.addSubview(circleBackground)
        circleBackground.addSubview(displayLabel)
    }
    
    private func setupConstraints() {
        circleBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        displayLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setDone() {
        displayLabel.text = "✓"
        displayLabel.font = .systemFont(ofSize: self.displayLabel.font.pointSize, weight: .bold)
        displayLabel.textColor = .white
        circleBackground.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0.49, alpha: 1)
    }
    
    private func setNumber(to number: Int) {
        let range = (0...9)
        
        if range ~= number {
            self.displayLabel.text = "\(number)"
        } else {
            self.displayLabel.text = "9+"
        }
        
        displayLabel.font = .boldSystemFont(ofSize: self.displayLabel.font.pointSize)
        displayLabel.textColor = UIColor(red: 0.365, green: 0.114, blue: 0.235, alpha: 1)
        circleBackground.backgroundColor = UIColor(red: 0.973, green: 0.953, blue: 0.831, alpha: 1)
    }
    
    /// Self.State의 케이스로 해당 뷰를 업데이트 하는 메소드
    /// - parameters:
    ///     - state: CircleCheckView.State
    func updateState(_ state: CircleCheckView.State) {
        switch state {
        case .display(let number):
            setNumber(to: number)
        case .done:
            setDone()
        }
    }
}

// MARK: - Nested Enum - CircleCheckView.State

extension CircleCheckView {
    
    /// CircleCheckView.State 타입
    ///
    /// Case:
    /// - done
    /// - display(number: Int)
    enum State {
        case done
        case display(number: Int)
    }
}
