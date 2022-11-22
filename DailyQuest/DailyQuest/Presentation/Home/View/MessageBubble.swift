//
//  MessageBubble.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/22.
//

import UIKit

final class MessageBubbleLabel: UILabel {
    private var topInset: CGFloat = 10.0
    private var bottomInset: CGFloat = 10.0
    private var leftInset: CGFloat = 15.0
    private var rightInset: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
        text = "hello world!"
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

        let bezierPath = UIBezierPath()
        let width = rect.width
        let height = rect.height
        
        bezierPath.move(to: CGPoint(x: 4, y: 25))
        bezierPath.addLine(to: CGPoint(x: 4, y: 20))
        bezierPath.addCurve(to: CGPoint(x: 20, y: 0),
                            controlPoint1: CGPoint(x: 4, y: 8),
                            controlPoint2: CGPoint(x: 12, y: 0))
        
        bezierPath.addLine(to: CGPoint(x: width - 20, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width, y: 20),
                            controlPoint1: CGPoint(x: width - 8, y: 0),
                            controlPoint2: CGPoint(x: width, y: 8))
        
        bezierPath.addLine(to: CGPoint(x: width, y: height - 20))
        bezierPath.addCurve(to: CGPoint(x: width - 20, y: height),
                            controlPoint1: CGPoint(x: width, y: height - 8),
                            controlPoint2: CGPoint(x: width - 8, y: height))
        
        bezierPath.addLine(to: CGPoint(x: 20, y: height))
        bezierPath.addCurve(to: CGPoint(x: 4, y: height - 4),
                            controlPoint1: CGPoint(x: 7, y: height),
                            controlPoint2: CGPoint(x: 5, y: height - 3))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height),
                            controlPoint1: CGPoint(x: 8, y: height - 3),
                            controlPoint2: CGPoint(x: 4, y: height - 2))


        UIColor.maxYellow.setFill()
        bezierPath.fill()
        bezierPath.close()

        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MessageBubblePreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let bubble = MessageBubbleLabel(frame: .zero)
            
            return bubble
        }
        .previewLayout(.fixed(width: 350, height: 80))
    }
}
#endif
