//
//  JSDimmingView.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

open class JSDimmingView: UIView {

    public struct Constants {
        public static let blackAlpha: CGFloat = 0.4
        public static let whiteAlpha: CGFloat = 0.5
    }
    
    // MARK:
    private var type: JSDimmingViewType
    
    // MARK:
    public init(type: JSDimmingViewType) {
        self.type = type
        super.init(frame: .zero)
        self.setBackground(type: type)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    private func setBackground(type: JSDimmingViewType) {
        switch type {
        case .white:
            self.backgroundColor = UIColor(white: 1.0, alpha: Constants.whiteAlpha)
        case .black:
            self.backgroundColor = UIColor(white: 0.0, alpha: Constants.blackAlpha)
        case .none:
            self.backgroundColor = UIColor.clear
        }
    }
}

extension JSDimmingView: JSObscurable {
    
    // MARK: Obscurable
    var view: UIView {
        return self
    }
    
    var isObscuring: Bool {
        set {
            self.setBackground(type: newValue ? self.type : .none)
        }
        get {
            return self.backgroundColor != UIColor.clear
        }
    }
}
