//
//  JSLockerPresentationController.swift
//  JSLocker
//
//  Created by Max on 2019/5/9.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class JSLockerPresentationController: UIPresentationController {

    private struct Constants {
        static let cornerRadius: CGFloat = 0.0
        static let minVerticalMargin: CGFloat = 20.0
    }
    
    enum ExtraContentHeightEffect: Int {
        case move
        case resize
    }
    
    // MAKR:
    let sourceViewController: UIViewController
    let sourceObject: Any?
    let origin: CGFloat?
    let direction: JSLockerPresentationDirection
    let isInteractive: Bool
    
    var extraContentHeightEffectWhenCollapsing: ExtraContentHeightEffect = .move
    
    private lazy var accessibilityContainer: UIView = {
        let view = UIView()
        view.accessibilityViewIsModal = true
        view.layer.mask = CALayer()
        view.layer.mask?.backgroundColor = UIColor.white.cgColor
        return view
    }()
    private lazy var backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.backgroundColor = UIColor.clear
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Dismiss"
        view.accessibilityHint = "Double Tap To Dismiss"
        view.accessibilityTraits = .button
        view.onAccessibilityActivate = { [unowned self] in
            self.presentingViewController.dismiss(animated: true)
        }
        return view
    }()
    private lazy var dimmingView: JSDimmingView = {
        let view = JSDimmingView(type: .black)
        view.isUserInteractionEnabled = false
        return view
    }()
    private lazy var actualPresentationOrigin: CGFloat = {
        if let origin = self.origin {
            return origin
        }
        switch self.direction {
        case .down:
            var viewController = self.sourceViewController
            while let navigationController = viewController.navigationController {
                let navigationBar = navigationController.navigationBar
                if !navigationBar.isHidden, let navigationBarParent = navigationBar.superview {
                    return navigationBarParent.convert(navigationBar.frame, to: nil).maxY
                }
                viewController = navigationController
            }
            return UIScreen.main.bounds.minY
        case .up:
            return UIScreen.main.bounds.maxY
        }
    }()
    private lazy var contentView = UIView()
    private lazy var shadowView = JSShadowView(direction: self.direction)
    private lazy var separator = JSSeparator(style: .shadow)
    
    private var extraContentHeight: CGFloat = 0.0
    
    // MARK:
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, sourceViewController: UIViewController, sourceObject: Any?, origin: CGFloat?, direction: JSLockerPresentationDirection, isInteractive: Bool) {
        self.sourceViewController = sourceViewController
        self.sourceObject = sourceObject
        self.origin = origin
        self.direction = direction
        self.isInteractive = isInteractive
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.backgroundView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewTapped(_:)))]
    }
    
    // MARK:
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.contentView.frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.containerView?.bringSubviewToFront(self.separator)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.setPresentedViewMask()
    }
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.accessibilityContainer)
        self.accessibilityContainer.fitIntoSuperview()
        
        self.accessibilityContainer.addSubview(self.backgroundView)
        self.backgroundView.fitIntoSuperview()
        
        self.backgroundView.addSubview(self.dimmingView)
        self.dimmingView.frame = self.frameForDimmingView(in: self.backgroundView.bounds)
        
        self.accessibilityContainer.layer.mask?.frame = self.dimmingView.frame
        
        self.accessibilityContainer.addSubview(self.contentView)
        self.contentView.frame = self.frameForContentView()
        
        self.contentView.addSubview(self.shadowView)
        self.shadowView.owner = self.presentedViewController.view
        
        if self.presentedViewController.transitionCoordinator?.isAnimated == true {
            self.contentView.addSubview(self.presentedViewController.view)
        }
        
        self.containerView?.addSubview(self.separator)
        self.separator.frame = self.frameForSeparator(in: self.contentView.frame, withThickness: self.separator.height)
        
        self.backgroundView.alpha = 0.0
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.backgroundView.alpha = 1.0
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            UIAccessibility.post(notification: .screenChanged, argument: self.contentView)
            UIAccessibility.post(notification: .announcement, argument: "Alert")
        }
        else {
            self.accessibilityContainer.removeFromSuperview()
            self.separator.removeFromSuperview()
            self.removePresentedViewMask()
            self.shadowView.owner = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if self.presentedViewController.transitionCoordinator?.isAnimated == true {
            self.contentView.addSubview(self.presentedViewController.view)
            self.presentedViewController.view.frame = self.contentView.bounds
        }
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.backgroundView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.accessibilityContainer.removeFromSuperview()
            self.separator.removeFromSuperview()
            self.removePresentedViewMask()
            self.shadowView.owner = nil
            UIAccessibility.post(notification: .screenChanged, argument: self.sourceObject)
        }
    }
    
    // MARK:
    func setExtraContentHeight(_ extraContentHeight: CGFloat, updatingLayout updateLayout: Bool = true, animated: Bool = false) {
        if self.extraContentHeight == extraContentHeight {
            return
        }
        self.extraContentHeight = extraContentHeight
        if updateLayout {
            self.updateContentViewFrame(animated: animated)
        }
    }
    
    func updateContentViewFrame(animated: Bool) {
        let newFrame = self.frameForContentView()
        if animated {
            let animationDuration = JSLockerTransitionAnimator.animationDuration(forSizeChange: newFrame.height - contentView.height)
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.layoutSubviews], animations: {
                self.setContentViewFrame(newFrame)
                self.animatePresentedViewMask(withDuration: animationDuration)
            })
        }
        else {
            self.setContentViewFrame(newFrame)
            self.setPresentedViewMask()
        }
    }
    
    // MARK:
    private func setContentViewFrame(_ frame: CGRect) {
        self.contentView.frame = frame
        if let presentedView = self.presentedView, presentedView.superview == containerView {
            presentedView.frame = self.frameOfPresentedViewInContainerView
        }
    }
    
    private func frameForSeparator(in bounds: CGRect, withThickness thickness: CGFloat) -> CGRect {
        return CGRect(
            x: bounds.minX,
            y: self.direction == .down ? bounds.minY : bounds.maxY - thickness,
            width: bounds.width,
            height: thickness
        )
    }
    
    private func frameForContentView(in bounds: CGRect) -> CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }
        var contentMargins: UIEdgeInsets = .zero
        switch self.direction {
        case .down:
            contentMargins.bottom = max(Constants.minVerticalMargin, containerView.safeAreaInsetsIfAvailable.bottom)
        case .up:
            contentMargins.top = max(Constants.minVerticalMargin, containerView.safeAreaInsetsIfAvailable.top)
        }
        var contentFrame = bounds.inset(by: contentMargins)
        var contentSize = self.presentedViewController.preferredContentSize
        contentSize.width = contentFrame.width
        switch self.direction {
        case .down:
            if self.actualPresentationOrigin == containerView.bounds.minY {
                contentSize.height += containerView.safeAreaInsetsIfAvailable.top
            }
        case .up:
            if self.actualPresentationOrigin == containerView.bounds.maxY {
                contentSize.height += containerView.safeAreaInsetsIfAvailable.bottom
            }
        }
        contentSize.height = min(contentSize.height, contentFrame.height)
        if self.extraContentHeight >= 0.0 || self.extraContentHeightEffectWhenCollapsing == .resize {
            contentSize.height = min(contentSize.height + extraContentHeight, contentFrame.height)
        }
        contentFrame.origin.x += (contentFrame.width - contentSize.width) / 2.0
        if self.direction == .up {
            contentFrame.origin.y = contentFrame.maxY - contentSize.height
        }
        if self.extraContentHeight < 0.0 && self.extraContentHeightEffectWhenCollapsing == .move {
            contentFrame.origin.y += self.direction == .down ? self.extraContentHeight : -self.extraContentHeight
        }
        contentFrame.size = contentSize
        return contentFrame
    }
    
    private func frameForContentView() -> CGRect {
        return self.frameForContentView(in: self.dimmingView.frame)
    }
    
    private func frameForDimmingView(in bounds: CGRect) -> CGRect {
        var margins: UIEdgeInsets = .zero
        switch self.direction {
        case .down:
            margins.top = self.actualPresentationOrigin
        case .up:
            margins.bottom = bounds.height - actualPresentationOrigin
        }
        return bounds.inset(by: margins)
    }
    
    private func setPresentedViewMask() {
        guard let presentedView = self.presentedView, !(presentedView.layer.mask?.isAnimating ?? false) else {
            return
        }
        let roundedCorners: UIRectCorner = self.direction == .down ? [.bottomLeft, .bottomRight] : [.topLeft, .topRight]
        presentedView.layer.mask = presentedView.layer(withRoundedCorners: roundedCorners, radius: Constants.cornerRadius)
    }
    
    private func removePresentedViewMask() {
        self.presentedView?.layer.mask = nil
    }
    
    private func animatePresentedViewMask(withDuration duration: TimeInterval) {
        guard let presentedView = self.presentedView else {
            return
        }
        let oldMaskPath = (presentedView.layer.mask as? CAShapeLayer)?.path
        self.shadowView.animate(withDuration: duration, animations: {
            self.setPresentedViewMask()
        })
        guard let presentedViewMask = presentedView.layer.mask as? CAShapeLayer else {
            return
        }
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = oldMaskPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        presentedViewMask.add(animation, forKey: animation.keyPath)
    }
    
    // MARK:
    @objc private func handleBackgroundViewTapped(_ recignizer: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true)
    }
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
