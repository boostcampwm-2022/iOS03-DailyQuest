//
//  CameraIconView.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/08.
//

import UIKit
import SnapKit

final class CameraIconView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 30.0 / 2
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.3
        return backgroundView
    }()
    
    
    private lazy var camaraImageView: UIImageView = {
        let camaraImageView = UIImageView()
        camaraImageView.image = UIImage(systemName: "camera.fill")
        camaraImageView.contentMode = .scaleAspectFit
        camaraImageView.tintColor = .gray
        return camaraImageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(camaraImageView)
    }
    
    private func setupConstraints() {
        camaraImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CameraIconViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = CameraIconView(frame: .zero)
            return view
        }.previewLayout(.fixed(width: 30, height: 30))
    }
}
#endif
