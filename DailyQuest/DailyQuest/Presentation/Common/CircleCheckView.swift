//
//  CircleCheckView.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/14.
//

import UIKit
import SnapKit

final class CircleCheckView: UIView {
    
    // MARK: - Sub Views
    
    private lazy var circleBackground: UIView = {
        let view = UIView()
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
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func setDone() {
        displayLabel.text = "✓"
        displayLabel.font = .systemFont(ofSize: self.displayLabel.font.pointSize, weight: .bold)
        displayLabel.textColor = .white
        circleBackground.backgroundColor = .maxYellow
    }
    
    func setNumber(to number: Int) {
        let range = (0...9)
        
        if range ~= number {
            self.displayLabel.text = "\(number)"
        } else {
            self.displayLabel.text = "9+"
        }
        
        displayLabel.font = .boldSystemFont(ofSize: self.displayLabel.font.pointSize)
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
        displayLabel.textColor = .maxViolet
        circleBackground.backgroundColor = .maxLightYellow
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
