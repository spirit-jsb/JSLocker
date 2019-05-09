//
//  JSLockerPresentationController.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class JSLockerPresentationController: UIPresentationController {

}

private class BackgroundView: UIView {
    
    // MAKR:
    var onAccessibilityActivate: (() -> Void)?
    
    // MARK:
    override func accessibilityActivate() -> Bool {
        self.onAccessibilityActivate?()
        return true
    }
}
