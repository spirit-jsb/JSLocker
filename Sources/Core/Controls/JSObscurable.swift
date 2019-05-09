//
//  JSObscurable.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

protocol JSObscurable: class {
    
    var view: UIView { get }
    var isObscuring: Bool { set get }
}

class JSObscurableFactory {
    
    static func obscurable(with obscureStyle: JSObscureStyle) -> JSObscurable {
        switch obscureStyle {
        case .blur:
            return JSBlurringView(style: .dark, backgroundAlpha: 0.0)
        case .dim:
            return JSDimmingView(type: .black)
        }
    }
}
