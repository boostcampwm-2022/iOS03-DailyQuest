//
//  UserInfoCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import UIKit

import SnapKit

final class UserInfoCell: UITableViewCell {
    /// dequeuResusable을 위한 아이덴티파이어입니다.
    static let reuseIdentifier = "UserInfoCell"
    
    // MARK: - Components
    /**
     이미지와 유저이름 레이블을 담기 위한 스택뷰입니다.
     수평 스택뷰이며, 중앙 정렬을 통해 각 아이템을 수직축 기준으로 중앙에 위치시켰습니다.
     Note. Color를 assets에 임의로 등록하였습니다. 동료들이 동일한 이름으로 동일한 색상을 등록할 수도 있으므로,
     이는 회고시간에 반드시 언급해야 합니다.
     */
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.backgroundColor = UIColor(named: "LightGray")
        container.spacing = 10
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        container.layer.cornerRadius = 15
        
        return container
    }()
    
    /**
     유저의 프로필 이미지가 들어갈 UIImageView입니다.
     Note. 원형의 틀을 만들기 위해, render loop의 `layoutSubviews()`메서드를 오버라이드하였음에 유념하세요.
     */
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(systemName: "heart.fill")
        userImage.clipsToBounds = true
        userImage.backgroundColor = .white
        
        return userImage
    }()
    
    /**
     유저의 닉네임이 들어갈 레이블입니다.
     */
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = " "
        
        return userName
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
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }
    
    /**
     UI의 constraints를 설정하기 위한 메서드입니다.
     constraints를 설정하기 전에, 해당 뷰를 먼저 add해야함을 유념하세요.
     */
    private func configureUI() {
        container.addArrangedSubview(userImage)
        container.addArrangedSubview(userName)
        addSubview(container)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-40)
            make.width.equalTo(userImage.snp.height)
        }
    }
    
    /**
     인자로 받은 Entity User타입을 통해 그 정보를 기반으로 cell에 아이템을 넣습니다.
     
     - Parameters:
        - user: User타입의 엔티티입니다.
     */
    func setup(with user: User) {
        userName.text = user.nickName
        guard let image = UIImage(data: user.profile) else { return }
        userImage.image = image
    }
}

/**
 SwiftUI 프리뷰 기능을 사용하기 위한 코드들 입니다.
 */
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UserInfoCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = UserInfoCell(frame: .zero)
            cell.setup(with: User(uuid: UUID(), nickName: "jinwoong", profile: Data(), backgroundImage: Data(), description: ""))
            return cell
        }
        .previewLayout(.fixed(width: 350, height: 80))
        .environment(\.dynamicTypeSize, .large)
    }
}
#endif
