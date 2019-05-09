//
//  JSSeparator.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

open class JSSeparator: UIView {

    // MARK:
    private var direction: JSSeparatorDirection = .horizontal
    
    // MARK:
    public init(style: JSSeparatorStyle = .default, direction: JSSeparatorDirection = .horizontal) {
        super.init(frame: .zero)
        self.initialize(style: style, direction: direction)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    open override var intrinsicContentSize: CGSize {
        switch self.direction {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: self.frame.height)
        case .vertical:
            return CGSize(width: self.frame.width, height: UIView.noIntrinsicMetric)
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch self.direction {
        case .horizontal:
            return CGSize(width: size.width, height: self.frame.height)
        case .vertical:
            return CGSize(width: self.frame.width, height: size.height)
        }
    }
    
    // MARK:
    private func initialize(style: JSSeparatorStyle, direction: JSSeparatorDirection) {
        self.backgroundColor = style.color
        self.direction = direction
        switch direction {
        case .horizontal:
            self.frame.size.height = 1.0 / UIScreen.main.scale
            self.autoresizingMask = .flexibleWidth
        case .vertical:
            self.frame.size.width = 1.0 / UIScreen.main.scale
            self.autoresizingMask = .flexibleHeight
        }
        self.isAccessibilityElement = false
        self.isUserInteractionEnabled = false
    }
}
