//
//  JSLockerConstants.swift
//  JSLocker
//
//  Created by Max on 2019/5/8.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

// MARK: JSLockerPresentationDirection
public enum JSLockerPresentationDirection: Int {
    case down  // locker animated down from a top base
    case up    // locker animated up from a bottom base
}

// MARK: JSObscureStyle
public enum JSObscureStyle: Int {
    case blur
    case dim
}

// MARK: JSDimmingViewType
public enum JSDimmingViewType: Int {
    case white = 1
    case black
    case none
}

// MAKR: JSSeparatorStyle
public enum JSSeparatorStyle: Int {
    case `default`
    case shadow
    
    var color: UIColor {
        switch self {
        case .default:
            return UIColor(hex: 0xE1E1E1)
        case .shadow:
            return UIColor.black.withAlphaComponent(0.3)
        }
    }
}

// MARK: JSSeparatorDirection
public enum JSSeparatorDirection: Int {
    case horizontal
    case vertical
}

// MARK:
public enum JSLockerResizingBehavior: Int {
    case none
    case dismiss
    case dismissOrExpand
}

// MARK:
@objc public protocol JSLockerControllerDelegate: class {
    
    @objc optional func lockerControllerDidChangeExpandedState(_ controller: JSLockerController)
    @objc optional func lockerControllerWillDismiss(_ controller: JSLockerController)
    @objc optional func lockerControllerDidDismiss(_ controller: JSLockerController)
}
