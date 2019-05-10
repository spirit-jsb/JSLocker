//
//  UIViewController+JSLocker.swift
//  JSLocker
//
//  Created by Max on 2019/5/10.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // MARK:
    func addChildController(_ childController: UIViewController) {
        self.addChild(childController)
        self.view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
}
