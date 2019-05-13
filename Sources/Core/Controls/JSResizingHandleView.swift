//
//  JSResizingHandleView.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class JSResizingHandleView: UIView {
    
    private struct Constants {
        static let markSize = CGSize(width: 36.0, height: 4.0)
        static let markCornerRadius: CGFloat = 2.0
    }
    
    // MARK:
    static let height: CGFloat = 20.0
    
    private let markLayer: CALayer = {
        let markLayer = CALayer()
        markLayer.backgroundColor = UIColor(hex: 0xE1E1E1).cgColor
        markLayer.bounds.size = Constants.markSize
        markLayer.cornerRadius = Constants.markCornerRadius
        return markLayer
    }()
    
    // MAKR:
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.height = JSResizingHandleView.height
        self.autoresizingMask = .flexibleWidth
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(self.markLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: JSResizingHandleView.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: JSResizingHandleView.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.markLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
}
