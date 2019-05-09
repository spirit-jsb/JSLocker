//
//  UIView+JSLocker.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension UIView {
    
    // MAKR:
    var left: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.minX
        }
    }
    
    var right: CGFloat {
        set {
            self.frame.origin.x = newValue - self.width
        }
        get {
            return self.frame.maxX
        }
    }
    
    var top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.minY
        }
    }
    
    var bottom: CGFloat {
        set {
            self.frame.origin.y = newValue - self.height
        }
        get {
            return self.frame.maxY
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.width
        }
    }
    
    var height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.height
        }
    }
    
    var safeAreaInsetsIfAvailable: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        }
        else {
            return .zero
        }
    }
    
    // MAKR:
    func fitIntoSuperview(usingConstraints: Bool = false,
                          usingLeadingTrailing: Bool = true,
                          margins: UIEdgeInsets = .zero,
                          autoWidth: Bool = false,
                          autoHeight: Bool = false)
    {
        guard let superview = self.superview else {
            return
        }
        if usingConstraints {
            self.translatesAutoresizingMaskIntoConstraints = false
            if usingLeadingTrailing {
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margins.left).isActive = true
            }
            else {
                self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margins.left).isActive = true
            }
            if autoWidth {
                if usingLeadingTrailing {
                    self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margins.right).isActive = true
                }
                else {
                    self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -margins.right).isActive = true
                }
            }
            else {
                self.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -(margins.left + margins.right)).isActive = true
            }
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margins.top).isActive = true
            if autoHeight {
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margins.bottom).isActive = true
            }
            else {
                self.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: -(margins.top + margins.bottom)).isActive = true
            }
        }
        else {
            self.translatesAutoresizingMaskIntoConstraints = true
            self.frame = superview.bounds.inset(by: margins)
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    func layer(withRoundedCorners corners: UIRectCorner, radius: CGFloat) -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: self.bounds,
                                  byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: radius, height: radius)).cgPath
        return layer
    }
}
