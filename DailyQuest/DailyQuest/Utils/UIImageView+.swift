//
//  UIImageView+.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/06.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        ImageCache.default.retriveImage(forkey: urlString, options: nil) { result in
            switch result {
            case .sucess(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
    }
}
