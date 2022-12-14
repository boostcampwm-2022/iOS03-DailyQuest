//
//  UIButton+.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import Kingfisher

extension UIButton.Configuration {
    public static func maxStyle() -> UIButton.Configuration {
        var style = UIButton.Configuration.plain()
        style.image = UIImage(systemName: "plus")
        style.baseForegroundColor = .maxViolet
        style.background.backgroundColor = .maxLightYellow
        style.cornerStyle = .capsule
        
        return style
    }
}

extension UIButton {
    func setImage(with urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
                case .success(let value):
                    if let image = value.image {
                        self.setImage(image, for: .normal)
                    } else {
                        guard let url = URL(string: urlString) else { return }
                        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                        self.kf.setImage(with: resource, for: .normal)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
