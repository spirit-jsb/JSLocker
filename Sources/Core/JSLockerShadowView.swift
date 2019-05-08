//
//  JSLockerShadowView.swift
//  JSLocker
//
//  Created by Max on 2019/5/8.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class JSLockerShadowView: UIView {
    
    private struct Constants {
        static let shadowRadius: CGFloat = 4.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 0.05
    }

    // MARK:
    var owner: UIView? {
        didSet {
            if let oldOwner = oldValue {
                oldOwner.removeObserver(self, forKeyPath: #keyPath(frame), context: nil)
                oldOwner.removeObserver(self, forKeyPath: #keyPath(bounds), context: nil)
                oldOwner.layer.removeObserver(self, forKeyPath: #keyPath(CALayer.mask), context: nil)
            }
            if let owner = self.owner {
                owner.addObserver(self, forKeyPath: #keyPath(frame), options: [], context: nil)
                owner.addObserver(self, forKeyPath: #keyPath(bounds), options: [], context: nil)
                owner.layer.addObserver(self, forKeyPath: #keyPath(CALayer.mask), options: [], context: nil)
            }
            self.updateFrame()
            self.updateShadowPath()
        }
    }
    
    private var animationDuration: TimeInterval = 0.0
    
    // MARK:
    init(direction: JSLockerPresentationDirection) {
        super.init(frame: .zero)
        self.isAccessibilityElement = false
        self.isUserInteractionEnabled = false
        self.layer.shadowRadius = Constants.shadowRadius
        self.layer.shadowOffset = CGSize(width: 0.0, height: Constants.shadowOffset * (direction == .down ? 1.0 : -1.0))
        self.layer.shadowOpacity = Constants.shadowOpacity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.owner = nil
    }
    
    // MAKR:
    func animate(withDuration duration: TimeInterval, animations: () -> Void) {
        self.animationDuration = duration
        animations()
        self.animationDuration = 0.0
    }
    
    // MARK:
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.updateFrame()
    }
    
    // MARK:
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let owner = self.owner {
            if object as? UIView == owner && (keyPath == #keyPath(frame) || keyPath == #keyPath(bounds)) {
                self.updateFrame()
                return
            }
            if object as? CALayer == owner.layer && keyPath == #keyPath(CALayer.mask) {
                self.updateShadowPath()
                return
            }
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    // MARK:
    private func updateFrame() {
        if let owner = self.owner, let ownerSuperview = owner.superview {
            self.frame = ownerSuperview.convert(owner.frame, to: self.superview)
        }
        else {
            self.frame = .zero
        }
    }
    
    private func updateShadowPath() {
        let oldShadowPath = self.layer.shadowPath
        self.layer.shadowPath = (owner?.layer.mask as? CAShapeLayer)?.path
        self.animateShadowPath(from: oldShadowPath)
    }
    
    private func animateShadowPath(from oldShadowPath: CGPath?) {
        if self.animationDuration == 0.0 {
            return
        }
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowPath))
        animation.fromValue = oldShadowPath
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(animation, forKey: animation.keyPath)
    }
}
