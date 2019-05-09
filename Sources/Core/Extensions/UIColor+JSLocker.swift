//
//  UIColor+JSLocker.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension UIColor {
    
    // MARK: 公开方法
    convenience init(hex: UInt32) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
