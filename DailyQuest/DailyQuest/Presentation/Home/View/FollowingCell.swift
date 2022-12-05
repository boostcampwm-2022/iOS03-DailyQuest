//
//  FollowingCell.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/30.
//

import UIKit
import SnapKit

final class FollowingCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FollowingCell"
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(systemName: "person.circle")
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = 35.0 / 2
        return userImage
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configure(with name: String?) {
        if name == nil {
            userImage.image = UIImage(systemName: "person.circle")
        } else{
            userImage.image = UIImage(named: name ?? "")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct FollowingCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = FollowingCell(frame: .zero)
            return cell
        }.previewLayout(.fixed(width: 40, height: 40))
    }
}
#endif
