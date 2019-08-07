//
//  UIView+Extension.swift
//  JSLocker-Demo
//
//  Created by Max on 2019/8/7.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

extension UIView {
    
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
}
