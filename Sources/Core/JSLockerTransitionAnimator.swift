//
//  JSLockerTransitionAnimator.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class JSLockerTransitionAnimator: NSObject {
    
    private  struct Constants {
        static let mimAnimationDuration: TimeInterval = 0.15
        static let maxAnimationDuration: TimeInterval = 0.25
        static let animationSpeed: CGFloat = 1300.0
    }

    // MARK:
    let presenting: Bool
    let direction: JSLockerPresentationDirection
    
    // MARK:
    init(presenting: Bool, direction: JSLockerPresentationDirection) {
        self.presenting = presenting
        self.direction = direction
        super.init()
    }
    
    // MARK:
    static func animationDuration(forSizeChange change: CGFloat) -> TimeInterval {
        let duration = TimeInterval(abs(change) / Constants.animationSpeed)
        return max(Constants.mimAnimationDuration, min(duration, Constants.maxAnimationDuration))
    }
    
    // MARK:
    private func presentWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning, completion: @escaping ((Bool) -> Void)) {
        let presentedView = transitionContext.view(forKey: .to)!
        let contentView = presentedView.superview!
        
        presentedView.frame = presentedViewRectDismissed(forContentSize: contentView.bounds.size)
        let animationDuration = JSLockerTransitionAnimator.animationDuration(forSizeChange: presentedView.frame.height)
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            presentedView.frame = self.presentedViewRectPresented(forContentSize: presentedView.frame.size)
        }, completion: completion)
    }
    
    private func dismissWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning, completion: @escaping ((Bool) -> Void)) {
        let presentedView = transitionContext.view(forKey: .from)!
        
        let animationDuration = JSLockerTransitionAnimator.animationDuration(forSizeChange: presentedView.frame.height)
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            presentedView.frame = self.presentedViewRectDismissed(forContentSize: presentedView.frame.size)
        }, completion: completion)
    }
    
    private func presentedViewRectPresented(forContentSize contentSize: CGSize) -> CGRect {
        return CGRect(x: 0.0, y: 0.0, width: contentSize.width, height: contentSize.height)
    }
    
    private func presentedViewRectDismissed(forContentSize contentSize: CGSize) -> CGRect {
        var rect = self.presentedViewRectPresented(forContentSize: contentSize)
        switch self.direction {
        case .down:
            rect.origin.y = -contentSize.height
        case .up:
            rect.origin.y = contentSize.height
        }
        return rect
    }
}

extension JSLockerTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    // MAKR: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            self.presentWithTransitionContext(transitionContext, completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
        }
        else {
            self.dismissWithTransitionContext(transitionContext, completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
