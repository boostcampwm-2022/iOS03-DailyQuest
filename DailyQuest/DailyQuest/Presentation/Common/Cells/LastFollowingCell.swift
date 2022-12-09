//
//  LastFollowingCell.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/01.
//

import UIKit

final class LastFollowingCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LastFollowingCell"
    
    private lazy var plusButton: UIButton = {
        var config = UIButton.Configuration.maxStyle()
        let plusButton = UIButton(configuration: config)
        
        return plusButton
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LastFollowingCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = LastFollowingCell(frame: .zero)
            return cell
        }.previewLayout(.fixed(width: 40, height: 40))
    }
}
#endif
