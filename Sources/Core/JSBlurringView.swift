//
//  JSBlurringView.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

open class JSBlurringView: UIView {

    public struct Constants {
        public static let defaultBackgroundColor: UIColor = UIColor.white
        public static let defaultBackgroundAlpha: CGFloat = 0.9
    }
    
    // MARK:
    private let blurEffect: UIBlurEffect
    private let visualEffectView: UIVisualEffectView
    private let backgroundView: UIView
    
    // MARK:
    public init(style: UIBlurEffect.Style, backgroundColor: UIColor = Constants.defaultBackgroundColor, backgroundAlpha: CGFloat = Constants.defaultBackgroundAlpha) {
        self.blurEffect = UIBlurEffect(style: style)
        self.visualEffectView = UIVisualEffectView(effect: self.blurEffect)
        
        self.backgroundView = UIView()
        self.backgroundView.backgroundColor = backgroundColor.withAlphaComponent(backgroundAlpha)
        
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = false
        
        self.addSubview(self.visualEffectView)
        self.addSubview(self.backgroundView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.visualEffectView.frame = self.bounds
        self.backgroundView.frame = self.bounds
    }
    
    // MARK:
    public func updateBackground(backgroundColor: UIColor, backgroundAlpha: CGFloat) {
        self.backgroundView.backgroundColor = backgroundColor.withAlphaComponent(backgroundAlpha)
    }
}

extension JSBlurringView: JSObscurable {
    
    // MARK: Obscurable
    var view: UIView {
        return self
    }
    
    var isObscuring: Bool {
        set {
            self.visualEffectView.effect = newValue ? self.blurEffect : nil
        }
        get {
            return self.visualEffectView.effect != nil
        }
    }
}
