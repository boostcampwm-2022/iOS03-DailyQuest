//
//  FollowingView.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/01.
//

import UIKit
import SnapKit

class FollowingView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Following"
        titleLabel.textColor = .maxViolet
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        return titleLabel
    }()
    
    private lazy var followingView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.itemSize = CGSize(width: 35, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(FollowingCell.self, forCellWithReuseIdentifier: FollowingCell.reuseIdentifier)
        collectionView.register(LastFollowingCell.self, forCellWithReuseIdentifier: LastFollowingCell.reuseIdentifier )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
        addSubview(titleLabel)
        addSubview(followingView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(75)
        }
        
        followingView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.height.equalTo(35)
        }
    }
}

extension FollowingView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

extension FollowingView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: LastFollowingCell.reuseIdentifier, for: indexPath) as? LastFollowingCell else {
                return UICollectionViewCell(frame: .zero)
            }
            return myCell
        } else {
            guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as? FollowingCell else {
                return UICollectionViewCell(frame: .zero)
            }
            myCell.configure(with: nil)
            return myCell
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct FollowingViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = FollowingView(frame: .zero)
            return view
        }.previewLayout(.sizeThatFits)
    }
}
#endif


