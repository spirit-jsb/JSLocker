//
//  CALayer+JSLocker.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension CALayer {
    
    // MARK: 公开属性
    var isAnimating: Bool {
        return self.animationKeys()?.isEmpty == false
    }
}
