//
//  SwiftUIPreview.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

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

enum DeviceType {
    case iPhoneSE2
    case iPhone8
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone14
    case iPhone14Pro
    
    func name() -> String {
        switch self {
            case .iPhoneSE2:
                return "iPhone SE"
            case .iPhone8:
                return "iPhone 8"
            case .iPhone12Pro:
                return "iPhone 12 Pro"
            case .iPhone12ProMax:
                return "iPhone 12 Pro Max"
            case .iPhone14:
                return "iPhone 14"
            case .iPhone14Pro:
                return "iPhone 14 Pro"
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {
    
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func showPreview(_ deviceType: DeviceType = .iPhone12Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif

// MARK: - Cell Preview
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct QuestCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = QuestCell(frame: .zero)
            /** Cell setup code */
            return cell
        }
        .previewLayout(.sizeThatFits)
    }
}

#endif
*/

// MARK: - View Controller Preview
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewController().showPreview(.iPhone8)
    }
}
#endif
*/
